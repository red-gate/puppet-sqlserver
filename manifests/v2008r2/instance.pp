# Install an configure a single SQL Server 2008 R2 Instance.
#
# $install_type: 'RTM', 'SP3'
#
define sqlserver::v2008r2::instance(
  $instance_name  = $title,
  $install_type   = 'SP3',
  $install_params = {},
  $tcp_port       = undef
  ) {

  require ::sqlserver::v2008r2::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $default_parameters = {
    sqlsvcaccount => 'NT AUTHORITY\NetworkService',
    agtsvcaccount => 'NT AUTHORITY\NetworkService',
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $::sqlserver::v2008r2::iso::installer,
    install_params => deep_merge($default_parameters, $install_params),
  }

  # 'Patch' is equivalent to 'SP4' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'SP3' {
    require ::sqlserver::v2008r2::sp3

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2008r2::sp3::installer,
      applies_to_version => $::sqlserver::v2008r2::sp3::applies_to_version,
    }
  }

  if $tcp_port {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

}
