# Execute a SQL script using sqlcmd.exe
define sqlserver::sqlcmd::sqlscript($server, $path, $unless = undef, $username = undef, $password = undef, $additional_arguments = '', $unless_additional_arguments = '', $refreshonly = false, $timeout = 300) {

  require sqlserver::sqlcmd::install

  if($::osfamily == 'windows')
  {
    $sqlcmd_name = 'sqlcmd.exe'
  }
  else
  {
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
