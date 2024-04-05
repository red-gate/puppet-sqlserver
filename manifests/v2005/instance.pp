# @summary Install an configure a single SQL Server 2005 Instance.
#
# @param instance_name
#   Name of the instance
# @param install_type
#  Installation type. 'RTM' or 'SP4'
# @param install_params
#   Hash of parameters to pass to SQL Installer
# @param tcp_port
#   TCP port to listen on
#
define sqlserver::v2005::instance (
  String $instance_name = $title,
  String $install_type = 'SP4',
  Hash $install_params = {},
  Integer $tcp_port= 0
) {
  if versioncmp($facts['kernelmajversion'], '6.2') >= 0 {
    fail('Installing SQL Server 2005 is not supported on this OS.')
  }

  require sqlserver::v2005::iso

  $major_version = 9

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
    addlocal                => 'SQL_Engine,SQL_Tools90',
    instancename            => $instance_name,
    installsqldatadir       => 'D:\\',
    sqlbrowseraccount       => 'NT AUTHORITY\LOCAL SERVICE',
    sqlaccount              => 'NT AUTHORITY\SYSTEM',
    agtaccount              => 'NT AUTHORITY\LOCAL SERVICE',
    asaccount               => 'NT AUTHORITY\LOCAL SERVICE',
    rsaccount               => 'NT AUTHORITY\LOCAL SERVICE',
    sqlcollation            => 'Latin1_General_CI_AS',
    sqlbrowserautostart     => 1,
    sqlautostart            => 1,
    agtautostart            => 1,
    asautostart             => 1,
    rsautostart             => 1,
    disablenetworkprotocols => 0,
    securitymode            => 'SQL',
    sapwd                   => 'YouBetterChangeThis!',
    username                => $facts['networking']['hostname'],
  }

  $params = deep_merge($default_parameters, $install_params)
  $parameters = convert_to_parameter_string_sql2005($params)

  exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${sqlserver::v2005::iso::installer}\" /qn ${parameters}",
    unless  => "reg.exe query ${get_instancename_from_registry}",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0, 3010],
  }

  if $instance_name in $facts['sqlserver_instances'] {
    $instance_registry_path = $facts['sqlserver_instances'][$instance_name][registry_path]

    if $install_type == 'Patch' or $install_type == 'SP4' {
      require sqlserver::v2005::sp4

      $get_patchlevel_from_registry = "\"HKLM\\${instance_registry_path}\\Setup\" /v PatchLevel"
      $collation = $params[sqlcollation]
      $sapwd = $params[sapwd]

      exec { "${instance_name} SP4":
        command   => "${sqlserver::v2005::sp4::installer} /quiet /instancename=${instance_name} /sapwd=${sapwd}",
        logoutput => true,
        returns   => ['0', '3010'],
        onlyif    => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${sqlserver::v2005::sp4::applies_to_version}",
        require   => [
          Exec["Install SQL Server instance: ${instance_name}"],
          Reboot["reboot before installing ${instance_name} Patch (if pending)"],
        ],
      }
    }
  } else {
    warning('Cannot retrieve SQL instance data from the $sqlserver_instances fact. Skip patching this SQL Server instance in this run.')
  }

  if $tcp_port > 0 {
    # Hacks for SQL Server 2005.
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }
}
