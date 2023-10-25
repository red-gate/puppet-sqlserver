# @summary Execute a SQL script using sqlcmd.exe
#
# @param server
#   The server to connect to
# @param path
#   The path to where sqlcmd is installed
# @param unless
#   An 'unless' check
# @param username
#   Username to authentication with
# @param password
#   Password for the user specified
# @param additional_arguments
#   Any additional argumens to pass
# @param unless_additional_arguments
#   Additional arguments to pass to the unless check
# @param refreshonly
#   Only run when notified
# @param timeout
#   Command timeout in seconds
define sqlserver::sqlcmd::sqlscript (
  String $server,
  String $path,
  Optional[String] $unless = undef,
  Optional[String] $username = undef,
  Optional[String] $password = undef,
  String $additional_arguments = '',
  String $unless_additional_arguments = '',
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
    $unlesssqlcmd = "${sqlcmd_name} -b -V 1 -S ${server} ${auth_arguments} -Q \"${unless}\" ${unless_additional_arguments}"
  } else {
    $unlesssqlcmd = undef
  }

  exec { "${title} - ${path}":
    path        => $sqlserver::sqlcmd::install::paths,
    command     => "${sqlcmd_name} -b -V 1 -S ${server} ${auth_arguments} -i \"${path}\" ${additional_arguments}",
    unless      => $unlesssqlcmd,
    refreshonly => $refreshonly,
    timeout     => $timeout,
  }
}
