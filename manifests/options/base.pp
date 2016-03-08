# Setup a SQL Server options using sqlcmd.exe and sp_configure
define sqlserver::options::base($server, $option_name, $option_value, $username = undef, $password = undef) {

  ensure_resource('sqlserver::sqlcmd',
    "${server} - Set show advanced options to 1",
    {
      'server'   => $server,
      'username' => $username,
      'password' => $password,
      'query'    => "exec sp_configure 'show advanced options', 1; reconfigure WITH override",
      'unless'   => "IF NOT EXISTS(SELECT * FROM sys.configurations WHERE name = 'show advanced options' and value_in_use = 1) raiserror ('Wrong value is in use',1,1)",
    })

  sqlserver::sqlcmd { "${server} - Set ${option_name} to ${option_value}":
    server   => $server,
    username => $username,
    password => $password,
    query    => "exec sp_configure '${option_name}', ${option_value}; reconfigure WITH override",
    unless   => "IF NOT EXISTS(SELECT * FROM sys.configurations WHERE name = '${option_name}' and value_in_use = ${option_value}) raiserror ('Wrong value is in use',1,1)",
    require  => Sqlserver::Sqlcmd["${server} - Set show advanced options to 1"],
  }

}
