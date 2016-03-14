# Install sqlcmd.exe
class sqlserver::sqlcmd::install($tempFolder = 'C:/temp') {

  include archive

  ensure_resource('file', $tempFolder, { ensure => directory })

  if $::architecture == 'x86' {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/1033/x86/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x86/MsSqlCmdLnUtils.msi'
  } else {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/1033/amd64/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x64/MsSqlCmdLnUtils.msi'
  }

  archive { "${tempFolder}/msodbcsql.msi":
    source  => $odbcdriver_source,
    require => File[$tempFolder],
  }
  ->
  package { 'Microsoft ODBC Driver 11 for SQL Server':
    ensure          => installed,
    source          => "${tempFolder}/msodbcsql.msi",
    install_options => ['ADDLOCAL=ALL', 'IACCEPTMSODBCSQLLICENSETERMS=YES'],
  }
  ->
  archive { "${tempFolder}/MsSqlCmdLnUtils.msi":
    source  => $sqlcmdutils_source,
  }
  ->
  package { 'Microsoft Command Line Utilities 11 for SQL Server':
    ensure          => installed,
    source          => "${tempFolder}/MsSqlCmdLnUtils.msi",
    install_options => ['IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES'],
  }
}
