# Execute a SQL script using sqlcmd.exe
define sqlserver::sqlcmd::sqlscript($server, $path, $unless = undef, $username = undef, $password = undef) {

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

  exec { "${title} - ${path}":
    path    => $sqlserver::sqlcmd::install::paths,
    command => "sqlcmd.exe -b -V 1 -S ${server} ${auth_arguments} -i \"${path}\"",
    unless  => $unlesssqlcmd,
  }

}
