# Install an configure a single SQL Server 2016 Instance.
define sqlserver::v2016::instance(
  $sa_password,
  $install_type              = 'SP1',
  $instance_name             = $title,
  $data_drive                = 'D',
  $log_drive                 = 'D',
  $backup_directory          = 'D:\Backups',
  $sql_collation             = 'Latin1_General_CI_AS',
  $sqlserver_service_account = undef,
  $tempdb_filesize           = 8,
  $tempdb_filegrowth         = 64
  ) {

  include ::sqlserver::reboot
  require ::sqlserver::v2016::resources

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $installer = "${::sqlserver::v2016::resources::temp_folder}/${::sqlserver::v2016::resources::isofilename_notextension}/setup.exe"
  $sp1_installer = "${::sqlserver::v2016::resources::temp_folder}/${::sqlserver::v2016::resources::sp1_filename_noextension}/setup.exe"

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
    command => "\"${installer}\" \
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
    require => [
      Class['::sqlserver::v2016::resources'],
      Reboot['reboot before installing SQL Server (if pending)']
    ],
  }
  ~>
  reboot { "reboot after installing SQL Server 2016 - ${instance_name}":
    when => pending,
  }

  if $install_type == 'SP1' {

    exec { "Install SQL Server SP1 instance: ${instance_name}":
      command => "\"${sp1_installer}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
/IACCEPTROPENLICENSETERMS \
/ACTION=Patch \
/INSTANCENAME=${instance_name}",
      unless  => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${::sqlserver::v2016::resources::sp1_patch_version}",
      require => [
        Exec["Install SQL Server instance: ${instance_name}"]
      ],
    }
    ~>
    reboot { "reboot after installing SP1 for ${instance_name}":
      when => pending,
    }

  }


}
