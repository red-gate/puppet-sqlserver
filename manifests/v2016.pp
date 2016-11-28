# Install SQL Server 2016
#
# $source: path to to the SQL Server 2016 Iso file.
#     (can be a UNC share / URL)
#
# $sa_password: The password for the sa account.
#
# $install_type: 'RTM' or 'SP1'. Defaults to SP1
#
# $temp_folder: path to a local folder where the SQL Server iso will be downloaded/extracted.
#
# $instance_name: The name of the SQL Server instance.
#
class sqlserver::v2016(
  $source,
  $sa_password,
  $install_type              = 'SP1',
  $temp_folder               = 'c:/temp',
  $instance_name             = 'SQL2016',
  $data_drive                = 'D',
  $log_drive                 = 'D',
  $backup_directory          = 'D:\Backups',
  $sql_collation             = 'Latin1_General_CI_AS',
  $sqlserver_service_account = undef,
  $reboot_timeout            = 60) {

  class { '::sqlserver::v2016::iso':
    source      => $source,
    temp_folder => $temp_folder,
  }
  ->
  sqlserver::v2016::instance { $instance_name:
    sa_password               => $sa_password,
    install_type              => $install_type,
    data_drive                => $data_drive,
    log_drive                 => $log_drive,
    backup_directory          => $backup_directory,
    sql_collation             => $sql_collation,
    sqlserver_service_account => $sqlserver_service_account,
  }

}
