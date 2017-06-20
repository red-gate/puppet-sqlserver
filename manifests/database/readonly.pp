# Set a database readonly
define sqlserver::database::readonly(
  $server,
  $database_name,
  $is_sql_2000 = false) {

  $unless_query = $is_sql_2000 ? {
    true => "IF databaseproperty('${database_name}', 'isreadonly') != 1 raiserror ('database readonly needs to be set',1,1)",
    false => "IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = '${database_name}' and is_read_only = 1) \
    raiserror ('database readonly needs to be set',1,1)",
  }

  ::sqlserver::sqlcmd::sqlquery { "${server} - Set ${database_name} to readonly":
    server => $server,
    query  => "ALTER DATABASE [${database_name}] SET READ_ONLY WITH NO_WAIT",
    unless => $unless_query,
  }
}
