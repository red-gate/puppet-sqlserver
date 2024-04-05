# @sumamry Execute a SQL query using sqlcmd.exe
# 
# @param server
#   Server to connect to
#
# @param query
#   The query to run
#
# @param unless
#   An unless check
#
# @param username
#   Username to authentication with
#
# @param password
#   Password for the user specified
#
# @param refreshonly
#   Only run when notified
#
# @param timeout
#   Execution timeout in secons.
define sqlserver::sqlcmd::sqlquery (
  String $server,
  String $query,
  Optional[String] $unless = undef,
  Optional[String] $username = undef,
  Optional[String] $password = undef,
  Boolean $refreshonly = false,
  Integer $timeout = 300
) {
  require sqlserver::sqlcmd::install

  if($facts['os']['family'] == 'windows') {
    $sqlcmd_name = 'sqlcmd.exe'
  }
  else {
    $sqlcmd_name = 'sqlcmd'
  }

  if $username {
    $auth_arguments = "-U \"${username}\" -P \"${password}\""
  } else {
    $auth_arguments = '-E'
  }

  if $unless {
    $unlesssqlcmd = "${sqlcmd_name} -b -V 1 -S ${server} ${auth_arguments} -Q \"${unless}\""
  } else {
    $unlesssqlcmd = undef
  }

  exec { $title:
    path        => $sqlserver::sqlcmd::install::paths,
    command     => "${sqlcmd_name} -b -V 1 -S ${server} ${auth_arguments} -Q \"${query}\"",
    unless      => $unlesssqlcmd,
    refreshonly => $refreshonly,
    timeout     => $timeout,
  }
}
