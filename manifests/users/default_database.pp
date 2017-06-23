# Set the default database for an existing login
define sqlserver::users::default_database(
  $server,
  $login_name,
  $default_database_name,
  $is_sql_2000 = false) {

  $sql_query = $is_sql_2000 ? {
    true  => "sp_defaultdb '${login_name}', '${default_database_name}'",
    false => "ALTER LOGIN [${login_name}] WITH DEFAULT_DATABASE = [${default_database_name}]",
  }

  $unless_query = $is_sql_2000 ? {
    true  => "IF NOT EXISTS(SELECT * FROM syslogins WHERE name = '${login_name}' and dbname = '${default_database_name}') \
    raiserror ('Default database value needs to be set',1,1)",
    false => "IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE name = '${login_name}' and default_database_name = '${default_database_name}') \
    raiserror ('Default database value needs to be set',1,1)",
  }

  ::sqlserver::sqlcmd::sqlquery { "${server} - Set ${login_name} default database to ${default_database_name}":
    server => $server,
    query  => $sql_query,
    unless => $unless_query,
  }
}
