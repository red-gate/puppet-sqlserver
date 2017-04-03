# Install an configure a single SQL Server 2005 Instance.
#
# $install_type:
#   'RTM' (don't patch)
#   or
#   'Patch' (install the latest Service Pack/Patch/CU we are aware of.)
#
define sqlserver::v2005::instance(
  $instance_name  = $title,
  $install_type   = 'Patch',
  $install_params = {},
  $tcp_port       = 0
  ) {

  if versioncmp($::kernelmajversion, '6.2') >= 0 {
    fail('Installing SQL Server 2005 is not supported on this OS.')
  }

  require ::sqlserver::v2005::iso

  $major_version = 9

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL${major_version}.${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"
  $get_instancename_from_registry = "\"HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL\" /v ${instance_name}"

  $instance_folder = $instance_name ? {
    'MSSQLSERVER' => 'MSSQL',
    default       => "MSSQL-${instance_name}",
  }

  sqlserver::common::reboot_resources { $instance_name: }

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $default_parameters = {
    addlocal            => 'SQL_Engine',
    instancename        => $instance_name,
    installsqldatadir   => "D:\\${instance_folder}\\Data",
    sqlbrowseraccount   => 'NT AUTHORITY\LOCAL SERVICE',
    sqlaccount          => 'NT AUTHORITY\NETWORK SERVICE',
    agtaccount          => 'NT AUTHORITY\LOCAL SERVICE',
    asaccount           => 'NT AUTHORITY\LOCAL SERVICE',
    rsaccount           => 'NT AUTHORITY\LOCAL SERVICE',
    sqlbrowserautostart => 1,
    sqlautostart        => 1,
    agtautostart        => 1,
    asautostart         => 1,
    rsautostart         => 1,
    securitymode        => 'SQL',
    sapwd               => 'YouBetterChangeThis!',
    username            => $::hostname,
  }

  $params = deep_merge($default_parameters, $install_params)
  $parameters = convert_to_parameter_string_sql2005($params)

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${::sqlserver::v2005::iso::installer}\" /qn ${parameters}",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0,1067,3010], # 1067 is Ok. SQL Server might fail to start but installing SP4 should fix it!
    notify  => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
  }

  if $install_type == 'Patch' {
    require ::sqlserver::v2005::sp4

    exec { "${instance_name} SP4":
      command   => "${::sqlserver::v2005::sp4::installer} /quiet /instancename=${instance_name}",
      logoutput => true,
      returns   => ['0', '3010'],
      onlyif    => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${::sqlserver::v2005::sp4::applies_to_version}",
      require   => Exec["Install SQL Server instance: ${instance_name}"]
      notify    => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
    }
  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port          => $tcp_port,
      sqlserver_version => $major_version,
    }
  }

}
