# Create a Windows authentication login
define sqlserver::users::login_windows($server, $login_name, $query_username = undef, $query_password = undef, $is_sql_2000 = false) {

  if $is_sql_2000 and $login_name =~ /[\\]/{
    $split = split($login_name, "\\\\")
    # For SQL Server 2000, the '<machine-name>' part in the login (<machine-name>\<username>)
    # must be uppercase. (if not the query will fail on instances configured with a case sensitive collation)
    $first_part = upcase($split[0])
    $second_part = $split[1]
    $fixedup_loginname = "${first_part}\\${second_part}"
  } else {
    $fixedup_loginname = $login_name
  }

  $sql_query = $is_sql_2000 ? {
    true  => "exec sp_grantlogin '${fixedup_loginname}'",
    false => "CREATE LOGIN [${fixedup_loginname}] FROM WINDOWS",
  }

  ::sqlserver::sqlcmd::sqlquery { "${server} - Create ${fixedup_loginname} login":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => $sql_query,
    unless   => "IF NOT EXISTS(SELECT * from master.dbo.syslogins WHERE loginname = '${fixedup_loginname}') raiserror ('Login does not exist',1,1)",
  }
}
