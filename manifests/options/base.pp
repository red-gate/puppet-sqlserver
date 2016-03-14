# Setup a SQL Server options using sqlcmd.exe and sp_configure
#
# $issql2000: table/column/options names can be different if targeting SQL Server 2000. Set this to $true if targeting SQL Server 2000
define sqlserver::options::base($server, $option_name, $option_value, $username = undef, $password = undef, $issql2000 = false) {

  if $issql2000 {
    $configuration_table = 'sysconfigures'
    $configuration_name_column = 'comment'
    $configuration_value_column = 'value'
  } else {
    $configuration_table = 'sys.configurations'
    $configuration_name_column = 'name'
    $configuration_value_column = 'value_in_use'
  }

  ensure_resource('sqlserver::sqlcmd::sqlquery',
    "${server} - Set show advanced options to 1",
    {
      'server'   => $server,
      'username' => $username,
      'password' => $password,
      'query'    => "exec sp_configure 'show advanced options', 1; reconfigure WITH override",
      'unless'   => "IF NOT EXISTS(SELECT * FROM ${configuration_table} WHERE ${configuration_name_column} = 'show advanced options' and ${configuration_value_column} = 1) raiserror ('Wrong value is in use',1,1)",
    })

  sqlserver::sqlcmd::sqlquery { "${server} - Set ${option_name} to ${option_value}":
    server   => $server,
    username => $username,
    password => $password,
    query    => "exec sp_configure '${option_name}', ${option_value}; reconfigure WITH override",
    unless   => "IF NOT EXISTS(SELECT * FROM ${configuration_table} WHERE ${configuration_name_column} = '${option_name}' and ${configuration_value_column} = ${option_value}) raiserror ('Wrong value is in use',1,1)",
    require  => Sqlserver::Sqlcmd::Sqlquery["${server} - Set show advanced options to 1"],
  }

}
