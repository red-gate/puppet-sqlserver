define sqlserver::common::install_sqlserver_instance(
  $installer_path,
  $instance_name  = $title,
  $install_params = {}
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
    installsqldatadir     => "D:\\Program Files\\Microsoft SQL Server",
    instancedir           => "D:\\Program Files\\Microsoft SQL Server",
    sqluserdbdir          => "D:\\${instance_folder}\\Data",
    sqluserdblogdir       => "D:\\${instance_folder}\\Log",
    sqlbackupdir          => "D:\\${instance_folder}\\Backups",
    sqltempdbdir          => "D:\\${instance_folder}\\Data",
    sqltempdblogdir       => "D:\\${instance_folder}\\Log",
    filestreamlevel       => 2,
    # filestreamsharename   => $title,
  }

  # Override the default parameters with parameters passed in $install_params
  $params = deep_merge($default_parameters, $install_params)

  sqlserver::common::reboot_resources { $instance_name: }

  $parameters = convert_to_parameter_string($params)

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${installer_path}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
${parameters}",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0,3010],
    notify  => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
  }

}
