# Install an configure a single SQL Server 2016 Instance.
#
# $install_type:
#   'RTM' (don't patch)
#   or
#   'Patch' (install the latest Service Pack/Patch we are aware of.)
#     The patch installed can be customized by using the ::sqlserver::v2016::patch class.
#
define sqlserver::v2016::instance(
  $sa_password,
  $install_type               = 'Patch',
  $instance_name              = $title,
  $features                   = 'SQL,Tools',
  $data_drive                 = 'D',
  $log_drive                  = 'D',
  $backup_directory           = 'D:\Backups',
  $sql_collation              = 'Latin1_General_CI_AS',
  $sqlserver_service_account  = undef,
  $tempdb_filesize            = 8,
  $tempdb_filegrowth          = 64,
  $browserservice_startuptype = 'Automatic',
  $namedpipes_enabled         = true,
  $tcpip_enabled              = true,
  $tcp_port                   = 0,
  ) {

  reboot { "reboot before installing ${instance_name} (if pending)":
    when => pending,
  }
  reboot { "reboot before installing ${instance_name} Patch (if pending)":
    when => pending,
  }
  reboot { "reboot after installing ${instance_name} Patch (if pending)":
    when => pending,
  }

  require ::sqlserver::v2016::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $instance_folder = $instance_name ? {
    'MSSQLSERVER' => 'MSSQL',
    default       => "MSSQL-${instance_name}",
  }

  $sqlsvcaccount = $sqlserver_service_account ? {
    undef   => "NT Service\\MSSQL$${instance_name}",
    default => $sqlserver_service_account,
  }

  $npenabled = bool2num($namedpipes_enabled)
  $tcpenabled = bool2num($tcpip_enabled)

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL13.${instance_name}"
  $get_instancename_from_registry = "\"HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL\" /v ${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${::sqlserver::v2016::iso::installer}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
/ACTION=install \
/FEATURES=${features} \
/INSTANCENAME=${instance_name} \
/SQLCOLLATION=${sql_collation} \
/SQLSYSADMINACCOUNTS=BUILTIN\\Administrators \
/SQLSVCACCOUNT=\"${sqlsvcaccount}\" \
/AGTSVCSTARTUPTYPE=Automatic \
/SQLSVCINSTANTFILEINIT=True \
/BROWSERSVCSTARTUPTYPE=${browserservice_startuptype} \
/SECURITYMODE=SQL \
/SAPWD=\"${sa_password}\" \
/NPENABLED=${npenabled} \
/TCPENABLED=${tcpenabled} \
/INSTALLSQLDATADIR=\"${data_drive}:\\Program Files\\Microsoft SQL Server\" \
/INSTANCEDIR=\"${data_drive}:\\Program Files\\Microsoft SQL Server\" \
/SQLUSERDBDIR=\"${data_drive}:\\${instance_folder}\\Data\" \
/SQLUSERDBLOGDIR=\"${log_drive}:\\${instance_folder}\\Log\" \
/SQLBACKUPDIR=\"${backup_directory}\" \
/SQLTEMPDBDIR=\"${data_drive}:\\${instance_folder}\\Data\" \
/SQLTEMPDBLOGDIR=\"${log_drive}:\\${instance_folder}\\Log\" \
/SQLTEMPDBFILESIZE=${tempdb_filesize} \
/SQLTEMPDBFILEGROWTH=${tempdb_filegrowth} \
/FILESTREAMLEVEL=2 \
/FILESTREAMSHARENAME=${instance_name}",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0,3010],
    notify  => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
  }

  if $install_type == 'Patch' {

    require ::sqlserver::v2016::patch

    exec { "Install SQL Server Patch instance: ${instance_name}":
      command => "\"${::sqlserver::v2016::patch::installer}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
/IACCEPTROPENLICENSETERMS \
/ACTION=Patch \
/INSTANCENAME=${instance_name}",
      unless  => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${::sqlserver::v2016::patch::version}",
      require => [
        Exec["Install SQL Server instance: ${instance_name}"],
        Reboot["reboot before installing ${instance_name} Patch (if pending)"]
      ],
      returns => [0,3010],
      notify  => Reboot["reboot after installing ${instance_name} Patch (if pending)"],
    }
  }

  ensure_resource('service', "SQLAGENT$${instance_name}", { ensure => running, })

  exec { "Restart MSSQL$${instance_name}":
    # Restart SQL Server ourselves so that we can pass /yes to net stop
    command     => "cmd.exe /c net stop \"MSSQL$${instance_name}\" /yes && net start \"MSSQL$${instance_name}\"",
    path        => 'C:/Windows/system32',
    refreshonly => true,
    # Make sure to refresh the SQL Agent service which is stopped when using net stop /yes
    notify      => Service["SQLAGENT$${instance_name}"],
  }

  if $tcp_port > 0 {

    registrykey { "${instance_name}: Disable dynamic ports":
      key     => "HKLM:\\${registry_instance_path}\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll",
      subName => 'TcpDynamicPorts',
      data    => '',
      require => Exec["Install SQL Server instance: ${instance_name}"],
    }
    ->
    registrykey { "${instance_name}: Set port to ${tcp_port}":
      key     => "HKLM:\\${registry_instance_path}\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll",
      subName => 'TcpPort',
      data    => $tcp_port,
      notify  => Exec["Restart MSSQL$${instance_name}"],
    }

  }

}
