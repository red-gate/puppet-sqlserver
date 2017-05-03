# Execute a SQL script using sqlcmd.exe
define sqlserver::sqlcmd::sqlscript($server, $path, $unless = undef, $username = undef, $password = undef) {

  require sqlserver::sqlcmd::install

  # The folders where to find sqlcmd.exe
  $paths = [
    'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/130/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/120/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/110/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/120/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/110/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/100/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/90/Tools/Binn',
    'C:/Program Files/Microsoft SQL Server/80/Tools/Binn',
  ]

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
    path    => $paths,
    command => "sqlcmd.exe -b -V 1 -S ${server} ${auth_arguments} -i \"${path}\"",
    unless  => $unlesssqlcmd,
  }

}
