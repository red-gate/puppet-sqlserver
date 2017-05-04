# Install sqlcmd.exe
class sqlserver::sqlcmd::install($temp_folder = 'C:/Windows/Temp') {

  require chocolatey
  include archive

  if $::architecture == 'x86' {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/ENU/x86/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x86/MsSqlCmdLnUtils.msi'
  } else {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/ENU/x64/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x64/MsSqlCmdLnUtils.msi'
  }

  archive { "${temp_folder}/msodbcsql.msi":
    source  => $odbcdriver_source,
  }
  ->
  package { 'Microsoft ODBC Driver 11 for SQL Server':
    ensure          => installed,
    source          => "${temp_folder}/msodbcsql.msi",
    install_options => ['ADDLOCAL=ALL', 'IACCEPTMSODBCSQLLICENSETERMS=YES'],
  }
  ->
  archive { "${temp_folder}/MsSqlCmdLnUtils.msi":
    source  => $sqlcmdutils_source,
  }
  ->
  package { 'Microsoft Command Line Utilities 11 for SQL Server':
    ensure          => installed,
    source          => "${temp_folder}/MsSqlCmdLnUtils.msi",
    install_options => ['IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES'],
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
