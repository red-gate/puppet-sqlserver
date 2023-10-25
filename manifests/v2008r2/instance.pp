# @summary Install an configure a single SQL Server 2008 R2 Instance.
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
# @param certificate_thumbprint
#   Thumbprint of an SSL cert in the local certificate store to use for SQL Connections
define sqlserver::v2008r2::instance (
  String $instance_name = $title,
  String $install_type = 'SP3',
  Hash $install_params = {},
  Optional[Integer] $tcp_port = undef,
  Optional[String] $certificate_thumbprint = undef,
) {
  require sqlserver::v2008r2::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $default_parameters = {
    sqlsvcaccount => 'NT AUTHORITY\NETWORK SERVICE',
    agtsvcaccount => 'NT AUTHORITY\NETWORK SERVICE',
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $sqlserver::v2008r2::iso::installer,
    install_params => deep_merge($default_parameters, $install_params),
    certificate_thumbprint => $certificate_thumbprint,
  }

  # 'Patch' is equivalent to 'SP4' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'SP3' {
    require sqlserver::v2008r2::sp3

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2008r2::sp3::installer,
      applies_to_version => $sqlserver::v2008r2::sp3::applies_to_version,
    }
  }

  if $tcp_port {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }
}
