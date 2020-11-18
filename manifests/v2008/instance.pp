# Install an configure a single SQL Server 2008 Instance.
#
# $install_type: 'RTM', 'SP3', 'SP4' or 'Jan2018CU'
#
define sqlserver::v2008::instance(
  $instance_name  = $title,
  $install_type   = 'SP4',
  $install_params = {},
  $tcp_port       = 0
  ) {

  require ::sqlserver::v2008::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $default_parameters = {
    # SQL Server 2008 does not support virtual account so default to
    # NetworkService if $install_params doesn't specifi sqlsvcaccount
    sqlsvcaccount => 'NT AUTHORITY\NetworkService',
    agtsvcaccount => 'NT AUTHORITY\NetworkService',
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $::sqlserver::v2008::iso::installer,
    install_params => deep_merge($default_parameters, $install_params),
    quiet_params   => '/QUIET', # SQL Server 2008 does not know about /IACCEPTSQLSERVERLICENSETERMS
  }

  # 'Patch' is equivalent to 'Jan2018CU' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'Jan2018CU' {
    require ::sqlserver::v2008::jan2018cu

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2008::jan2018cu::installer,
      applies_to_version => $::sqlserver::v2008::jan2018cu::applies_to_version,
    }
  }
  elsif $install_type == 'SP4' {
    require ::sqlserver::v2008::sp4

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2008::sp4::installer,
      applies_to_version => $::sqlserver::v2008::sp4::applies_to_version,
    }
  }
  elsif $install_type == 'SP3' {
    require ::sqlserver::v2008::sp3

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $::sqlserver::v2008::sp3::installer,
      applies_to_version => $::sqlserver::v2008::sp3::applies_to_version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

}
