# Install SQL Server 2017
#
# $source: path to to the SQL Server 2017 Iso file.
#     (can be a UNC share / URL)
#
# $sa_password: The password for the sa account.
#
# $install_type: 'RTM' or 'Patch'. Defaults to 'Patch'
#   'Patch' will upgrade SQL Server to the latest Service Pack.
#
# $instance_name: The name of the SQL Server instance.
#
class sqlserver::v2017(
  $source,
  $sa_password,
  $install_type   = 'Patch',
  $instance_name  = 'SQL2017') {

  class { '::sqlserver::v2017::iso':
    source      => $source,
  }
  ->
  sqlserver::v2017::instance { $instance_name:
    install_type   => $install_type,
    install_params => {
      sapwd => $sa_password,
    }
  }

}
