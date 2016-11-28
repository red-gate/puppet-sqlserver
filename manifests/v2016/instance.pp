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
  $install_type              = 'Patch',
  $instance_name             = $title,
  $data_drive                = 'D',
  $log_drive                 = 'D',
  $backup_directory          = 'D:\Backups',
  $sql_collation             = 'Latin1_General_CI_AS',
  $sqlserver_service_account = undef,
  $tempdb_filesize           = 8,
  $tempdb_filegrowth         = 64
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

  $get_instancename_from_registry = "\"HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL\" /v ${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL13.${instance_name}\\Setup\" /v PatchLevel"

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${::sqlserver::v2016::iso::installer}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
/ACTION=install \
/FEATURES=SQL,IS,Tools \
/INSTANCENAME=${instance_name} \
/SQLCOLLATION=${sql_collation} \
/SQLSYSADMINACCOUNTS=BUILTIN\\Administrators \
/SQLSVCACCOUNT=\"${sqlsvcaccount}\" \
/AGTSVCSTARTUPTYPE=Automatic \
/SQLSVCINSTANTFILEINIT=True \
/SECURITYMODE=SQL \
/SAPWD=\"${sa_password}\" \
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


}
