# Assign a database role to a login
# @summary Assigns a database role to a user
#
# @param server
#  The SQL Server instance to connect to
# @param login_name
#  The login name to assign the role to
# @param role_name
#  The role name to assign to the login
# @param database_name
#  The database name where the role assignment will take place
# @param query_username
#  The username to use for the SQL query (optional)
# @param query_password
#  The password to use for the SQL query (optional)

define sqlserver::users::db_role (
  String $server,
  String $login_name,
  String $role_name,
  String $database_name,
  String[Optional]  $query_username = undef,
  String[Optional] $query_password = undef
) {

  sqlserver::sqlcmd::sqlquery { "${server} - Create user ${login_name} for login ${login_name} on database ${database_name}":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => "USE [${database_name}] CREATE USER ${login_name} FOR LOGIN ${login_name}",
    unless   => "USE [${database_name}] IF(SELECT count(name) FROM sysusers where name = '${login_name}') != 1 raiserror('User is not created yet',1,1)",
  }

  sqlserver::sqlcmd::sqlquery { "${server} - Add role ${role_name} to ${login_name} login for database ${database_name}":
    server   => $server,
    username => $query_username,
    password => $query_password,
    query    => "USE [${database_name}] ALTER ROLE [${role_name}] ADD MEMBER [${login_name}]",
    unless   => "IF(SELECT IS_ROLEMEMBER('${role_name}', '${login_name}')) != 1 raiserror ('Role is not assigned yet',1,1)",
    require  => Sqlserver::Sqlcmd::Sqlquery["${server} - Create user ${login_name} for login ${login_name} on database ${database_name}"],
  }
}
