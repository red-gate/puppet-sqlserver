# Install SQL Server 2016
#
# $source: path to to the SQL Server 2016 Iso file.
#     (can be a UNC share / URL)
#
# $sa_password: The password for the sa account.
#
# $install_type: 'RTM' or 'SP1'. Defaults to SP1
#
# $instance_name: The name of the SQL Server instance.
#
class sqlserver::v2016(
  $source,
  $sa_password,
  $install_type   = 'Patch',
  $instance_name  = 'SQL2016',
  $reboot_timeout = 60) {

  class { '::sqlserver::v2016::iso':
    source      => $source,
  }
  ->
  sqlserver::v2016::instance { $instance_name:
    install_type   => $install_type,
    install_params => {
      sapwd => $sa_password,
    }
  }

}
