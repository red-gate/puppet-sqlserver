# Execute a SQL query using sqlcmd.exe
define sqlserver::sqlcmd::sqlquery($server, $query, $unless = undef, $username = undef, $password = undef, $refreshonly = false, $timeout = 300) {

  require sqlserver::sqlcmd::install

  if $username {
    $auth_arguments = "-U \"${username}\" -P \"${password}\""
  } else {
    $auth_arguments = '-E'
  }

  if $unless {
    $unlesssqlcmd = "sqlcmd.exe -b -V 1 -S ${server} ${auth_arguments} -Q \"${unless}\""
  } else {
    $unlesssqlcmd = undef
  }

  exec { $title:
    path        => $sqlserver::sqlcmd::install::paths,
    command     => "sqlcmd.exe -b -V 1 -S ${server} ${auth_arguments} -Q \"${query}\"",
    unless      => $unlesssqlcmd,
    refreshonly => $refreshonly,
    timeout     => $timeout,
  }

}
