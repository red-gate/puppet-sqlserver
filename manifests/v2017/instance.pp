# @summary Install an configure a single SQL Server 2017 Instance.
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
define sqlserver::v2017::instance (
  String $instance_name  = $title,
  String $install_type   = 'Patch',
  Hash $install_params = {},
  Integer $tcp_port       = 0
) {
  require sqlserver::v2017::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $sqlserver::v2017::iso::installer,
    install_params => $install_params,
  }

# Patch is not yet supported for SQL Server 2017, so do just act like base install
#  if $install_type == 'Patch' {
#    require ::sqlserver::v2017::patch

#    sqlserver::common::patch_sqlserver_instance { $instance_name:
#      installer_path     => $::sqlserver::v2017::patch::installer,
#      applies_to_version => $::sqlserver::v2017::patch::applies_to_version,
#    }
#  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }
}
