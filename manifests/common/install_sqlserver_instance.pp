# Install a single SQL Server instance
#
# $installer_path: Full path to setup.exe
#
# $instance_name: The name of the SQL Server instance to install
#
# $install_params: a Hash of the parameters to pass to setup.exe
#    Example: install_params => {
#      features     => 'SQL,Tools',
#      sqlcollation => 'Latin1_General_CI_AS',
#      securitymode => 'SQL',
#      sapwd        => 'YouBetterChangeThis!',
#    }
#
# $quiet_params: can be used to pass additional parameters for quiet mode.
#   defaults to '/QUIET /IACCEPTSQLSERVERLICENSETERMS'
#   could be set to '/QUIET' only for versions of SQL Server that do not support /IACCEPTSQLSERVERLICENSETERMS
#
define sqlserver::common::install_sqlserver_instance(
  $installer_path,
  $instance_name  = $title,
  $install_params = {},
  $quiet_params = '/QUIET /IACCEPTSQLSERVERLICENSETERMS'
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

  sqlserver::common::reboot_resources { $instance_name: }

  $parameters = convert_to_parameter_string($params)

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${installer_path}\" ${quiet_params} ${parameters}",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0,3010],
    notify  => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
  }

}
