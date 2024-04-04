# @summary Install a single SQL Server instance
#
# @param installer_path
#    Full path to setup.exe
#
# @param instance_name
#    The name of the SQL Server instance to install
#
# @param install_params
#   A Hash of the parameters to pass to setup.exe
#    Example: install_params => {
#      features     => 'SQL,Tools',
#      sqlcollation => 'Latin1_General_CI_AS',
#      securitymode => 'SQL',
#      sapwd        => 'YouBetterChangeThis!',
#    }
#
# @param quiet_params
#   Can be used to pass additional parameters for quiet mode.
#   defaults to '/QUIET /IACCEPTSQLSERVERLICENSETERMS'
#   could be set to '/QUIET' only for versions of SQL Server that do not support /IACCEPTSQLSERVERLICENSETERMS
#
# @param certificate_thumbprint
#   Thumbprint of a TLS cert in the Certificate store to use for SQL Server connections.
#
define sqlserver::common::install_sqlserver_instance (
  String $installer_path,
  String $instance_name  = $title,
  Hash $install_params = {},
  String $quiet_params = '/QUIET /IACCEPTSQLSERVERLICENSETERMS',
  Optional[String] $certificate_thumbprint = undef,
) {
  $get_instancename_from_registry = "\"HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL\" /v ${instance_name}"

  $instance_folder = $instance_name ? {
    'MSSQLSERVER' => 'MSSQL',
    default       => "MSSQL-${instance_name}",
  }

  $default_parameters = {
    action                => 'install',
    features              => 'SQL,Tools',
    instancename          => $instance_name,
    sqlcollation          => 'Latin1_General_CI_AS',
    sqlsysadminaccounts   => 'BUILTIN\\Administrators',
    sqlsvcaccount         => "NT Service\\MSSQL$${instance_name}",
    agtsvcstartuptype     => 'Automatic',
    browsersvcstartuptype => 'Automatic',
    securitymode          => 'SQL',
    sapwd                 => 'YouBetterChangeThis!',
    npenabled             => 1,
    tcpenabled            => 1,
    installsqldatadir     => 'D:\Program Files\Microsoft SQL Server',
    instancedir           => 'D:\Program Files\Microsoft SQL Server',
    sqluserdbdir          => "D:\\${instance_folder}\\Data",
    sqluserdblogdir       => "D:\\${instance_folder}\\Log",
    sqlbackupdir          => "D:\\${instance_folder}\\Backups",
    sqltempdbdir          => "D:\\${instance_folder}\\Data",
    sqltempdblogdir       => "D:\\${instance_folder}\\Log",
    filestreamlevel       => 2,
    filestreamsharename   => $instance_name,
  }

  # Override the default parameters with parameters passed in $install_params
  $params = deep_merge($default_parameters, $install_params)

  $parameters = convert_to_parameter_string($params)

  $svc_account = $params['sqlsvcaccount']

  # If the instance isn't already in the list of installed instances, we probably need to install it, so let's do a reboot 
  # if there's one pending before doing the installation.
  if (!$facts['sqlserver_instances'][$instance_name]) {
    reboot { "reboot before installing ${instance_name} (if pending)":
      when  => pending,
      apply => 'immediately',
      before => Exec["Install SQL Server instance: ${instance_name}"],
    }
  }

  # Install the SQL instance
  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${installer_path}\" ${quiet_params} ${parameters} /SkipRules=ServerCoreBlockUnsupportedSxSCheck",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    returns => [0,3010],
  }

  # If a cert is specified, configure it here _after_ SQL Server has been installed.
  if ($certificate_thumbprint) {
    # Include instance name here to avoid duplicate declarations where more than one SQL instance exists on the same server
    sslcertificate::key_acl { "${instance_name}_${svc_account}_certificate_read":
      identity        => $svc_account,
      cert_thumbprint => $certificate_thumbprint,
      require => Exec["Install SQL Server instance: ${instance_name}"],
    }

    sqlserver::common::set_tls_cert { "Set_TLS_certificate_for_${instance_name}":
      certificate_thumbprint => $certificate_thumbprint,
      instance_name => $instance_name,
      require => Sslcertificate::Key_acl["${instance_name}_${svc_account}_certificate_read"],
    }
  }
}
