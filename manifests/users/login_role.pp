# Assign a role to a login
define sqlserver::users::login_role($server, $login_name, $role_name, $query_username = undef, $query_password = undef) {

  ::sqlserver::sqlcmd::sqlquery { "${server} - Add role ${role_name} to ${login_name} login":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => "EXEC sp_addsrvrolemember '${login_name}', '${role_name}'",
    unless   => @("QUERY")
      IF NOT EXISTS(
        SELECT
          *
        FROM
          sys.server_role_members AS SRM
          JOIN sys.server_principals AS SP ON SRM.Role_principal_id = SP.principal_id
          JOIN sys.server_principals AS SP2 ON SRM.member_principal_id = SP2.principal_id
        WHERE
          SP.[name] = '${role_name}'
          AND SP2.[name] = '${login_name}'
      )
        raiserror ('Role is not assigned yet',1,1)
      | QUERY
      ,
  }

}
