# Install sqlcmd.exe
class sqlserver::sqlcmd::install(
  $version = '11',
  $temp_folder = 'C:/Windows/Temp') {

  case $version {
    '11': { include sqlserver::sqlcmd::install::v11 }
    '10': { include sqlserver::sqlcmd::install::v10 }
    default: { fail("version must be either 10 or 11. ${version} is not supported.") }
  }

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
}
