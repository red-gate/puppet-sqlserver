# Assign a role to a login
define sqlserver::users::login_role($server, $login_name, $role_name, $query_username = undef, $query_password = undef) {
  ::sqlserver::sqlcmd::sqlquery { "${server} - Add role ${role_name} to ${login_name} login":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => "EXEC sp_addsrvrolemember '${login_name}', '${role_name}'",
    unless   => "IF (SELECT IS_SRVROLEMEMBER('${role_name}', '${login_name}')) != 1 raiserror ('Role is not assigned yet',1,1)",
  }
}
