# Execute a SQL query using sqlcmd.exe
define sqlserver::sqlcmd::sqlquery($server, $query, $unless = undef, $username = undef, $password = undef) {

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
    $authArguments = "-U \"${username}\" -P \"${password}\""
  } else {
    $authArguments = '-E'
  }

  if $unless {
    $unlesssqlcmd = "sqlcmd.exe -b -V 1 -S ${server} ${authArguments} -Q \"${unless}\""
  } else {
    $unlesssqlcmd = undef
  }

  exec { "${title} - ${query}":
    path    => $paths,
    command => "sqlcmd.exe -b -V 1 -S ${server} ${authArguments} -Q \"${query}\"",
    unless  => $unlesssqlcmd,
  }

}
