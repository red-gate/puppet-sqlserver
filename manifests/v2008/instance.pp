# @sumamry Install an configure a single SQL Server 2008 Instance.
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
define sqlserver::v2008::instance (
  String $instance_name = $title,
  String $install_type = 'SP4',
  Hash $install_params = {},
  Integer $tcp_port = 0,
  String[Optional] $certificate_thumbprint = undef,
) {
  require sqlserver::v2008::iso

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

  $final_install_params = depp_merge($default_parameters, $install_params)

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $sqlserver::v2008::iso::installer,
    install_params => $final_install_params,
    quiet_params   => '/QUIET', # SQL Server 2008 does not know about /IACCEPTSQLSERVERLICENSETERMS
  }

  # 'Patch' is equivalent to 'Jan2018CU' for backwards compatibility
  if $install_type == 'Patch' or $install_type == 'Jan2018CU' {
    # Install SP4, then the Jan 2018 cumulative update
    require sqlserver::v2008::sp4
    require sqlserver::v2008::jan2018cu

    sqlserver::common::patch_sqlserver_instance { "${instance_name}-sp4":
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2008::sp4::installer,
      applies_to_version => $sqlserver::v2008::sp4::applies_to_version,
    }

    sqlserver::common::patch_sqlserver_instance { "${instance_name}-2018cu":
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2008::jan2018cu::installer,
      applies_to_version => $sqlserver::v2008::jan2018cu::applies_to_version,
      require            => Sqlserver::Common::Patch_sqlserver_instance["${instance_name}-sp4"],
    }
  }
  elsif $install_type == 'SP4' {
    require sqlserver::v2008::sp4

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2008::sp4::installer,
      applies_to_version => $sqlserver::v2008::sp4::applies_to_version,
    }
  }
  elsif $install_type == 'SP3' {
    require sqlserver::v2008::sp3

    sqlserver::common::patch_sqlserver_instance { $instance_name:
      instance_name      => $instance_name,
      installer_path     => $sqlserver::v2008::sp3::installer,
      applies_to_version => $sqlserver::v2008::sp3::applies_to_version,
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

  if ($certificate_thumbprint) {
    $svc_account = $final_install_params['sqlsvcaccount']
    sslcertificate::key_acl { "${svc_account}_certificate_read":
      identity        => $svc_account,
      cert_thumbprint => $certificate_thumbprint,
      require         => Sqlserver::Common::Install_sqlserver_instance[$instance_name],
    }

    sqlserver::common::set_tls_cert { "Set_TLS_certificate_for_${instance_name}":
      certificate_thumbprint => $certificate_thumbprint,
      instance_name => $instance_name,
      require => [Sqlserver::Common::Install_sqlserver_instance[$instance_name], Sslcertificate::Key_acl["${svc_account}_certificate_read"]],
    }
  }
}
