# Install an configure a single SQL Server 2016 Instance.
#
# $install_type: 'RTM' or 'SP1'
#
define sqlserver::v2016::instance(
  $instance_name  = $title,
  $install_type   = 'SP1',
  $install_params = {},
  $tcp_port       = 0
  ) {

  require ::sqlserver::v2016::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $::sqlserver::v2016::iso::installer,
    install_params => $install_params,
  }

  # 'Patch' is equivalent to 'SP1' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'SP1' {
    require ::sqlserver::v2016::sp1

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      installer_path     => $::sqlserver::v2016::sp1::installer,
      applies_to_version => $::sqlserver::v2016::sp1::applies_to_version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

}
