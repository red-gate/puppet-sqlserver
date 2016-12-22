# Install an configure a single SQL Server 2014 Instance.
#
# $install_type:
#   'RTM' (don't patch)
#   or
#   'Patch' (install the latest Service Pack/Patch we are aware of.)
#     The patch installed can be customized by using the ::sqlserver::v2014::patch class.
#
define sqlserver::v2014::instance(
  $instance_name  = $title,
  $install_type   = 'Patch',
  $install_params = {},
  $tcp_port       = 0
  ) {

  require ::sqlserver::v2014::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $::sqlserver::v2014::iso::installer,
    install_params => $install_params,
  }

  if $install_type == 'Patch' {
    require ::sqlserver::v2014::patch

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      installer_path => $::sqlserver::v2014::patch::installer,
      patch_version  => $::sqlserver::v2014::patch::version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port          => $tcp_port,
      sqlserver_version => 12,
    }
  }

}
