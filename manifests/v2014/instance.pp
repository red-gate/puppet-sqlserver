# Install an configure a single SQL Server 2014 Instance.
#
# $install_type: 'RTM', 'SP1', 'SP2'
#
define sqlserver::v2014::instance(
  $instance_name  = $title,
  $install_type   = 'SP2',
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

  # 'Patch' is equivalent to 'SP2' for backwards compatibility
  if $install_type == 'SP2' or $install_type == 'Patch' {
    require ::sqlserver::v2014::sp2
    require ::sqlserver::v2014::kb3194714

    sqlserver::common::patch_sqlserver_instance { "${instance_name}:${::sqlserver::v2014::sp2::installer}":
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2014::sp2::installer,
      applies_to_version => $::sqlserver::v2014::sp2::applies_to_version,
    }
    ->
    sqlserver::common::patch_sqlserver_instance { "${instance_name}:${::sqlserver::v2014::kb3194714::installer}":
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2014::kb3194714::installer,
      applies_to_version => $::sqlserver::v2014::kb3194714::applies_to_version,
    }
  }
  elsif $install_type == 'SP1' {
    require ::sqlserver::v2014::sp1

    sqlserver::common::patch_sqlserver_instance { "${instance_name}:${::sqlserver::v2014::sp1::installer}":
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2014::sp1::installer,
      applies_to_version => $::sqlserver::v2014::sp1::applies_to_version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

}
