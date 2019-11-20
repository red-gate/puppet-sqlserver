# Create a SQL login
define sqlserver::users::login_sql($server, $login_name, $password, $query_username = undef, $query_password = undef) {

  $sql_query = "CREATE LOGIN [${login_name}] WITH PASSWORD = '${password}'"

  ::sqlserver::sqlcmd::sqlquery { "${server} - Create ${login_name} login - SQL Server Auth":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => $sql_query,
    unless   => "IF NOT EXISTS(SELECT * from master.dbo.syslogins WHERE loginname = '${login_name}' AND isntname = 0) raiserror ('Login does not exist',1,1)",
  }
}
