# @summary Install an configure a single SQL Server 2012 Instance.
#
# @param instance_name 
#   Name of the instance being installed
#
# @param install_type
#   Type of install. Specify a Patch level to also install the related patch.
#   Can be RTM, SP3, SP4 or Jan2018CU
#
# @param install_params
#   Hash of install parameters to pass to the SQL installer
#
# @param tcp_port
#   Specify the TCP port to listen on 
#
define sqlserver::v2012::instance (
  String $instance_name  = $title,
  String $install_type   = 'SP3',
  Hash $install_params = {},
  Integer $tcp_port       = 0,
) {
  require sqlserver::v2012::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $sqlserver::v2012::iso::installer,
    install_params => $install_params,
  }

  # 'Patch' is equivalent to 'SP3' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'SP3' {
    require sqlserver::v2012::sp3

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2012::sp3::installer,
      applies_to_version => $sqlserver::v2012::sp3::applies_to_version,
    }
  }
  elsif $install_type == 'SP2' {
    require sqlserver::v2012::sp2

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2012::sp2::installer,
      applies_to_version => $sqlserver::v2012::sp2::applies_to_version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }
}
