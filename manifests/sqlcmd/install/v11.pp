# @summary Install sqlcmd.exe
#
# @param temp_folder
#   Location of a temp folder.
class sqlserver::sqlcmd::install::v11 (
  String $temp_folder = 'C:/Windows/Temp'
) {
  include archive

  if $facts['os']['architecture'] == 'x86' {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/ENU/x86/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x86/MsSqlCmdLnUtils.msi'
  } else {
    $odbcdriver_source = 'https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/ENU/x64/msodbcsql.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/5/5/B/55BEFD44-B899-4B54-ACD7-506E03142B34/1033/x64/MsSqlCmdLnUtils.msi'
  }

  #archive { "${temp_folder}/msodbcsql_v11.msi":
  #  source  => $odbcdriver_source,
  #}

  ::sqlserver::common::download_microsoft_file { 'msodbcsql_v11.msi':
    source => $odbcdriver_source,
    destination => "${temp_folder}/msodbcsql_v11.msi"
  }

  -> package { 'Microsoft ODBC Driver 11 for SQL Server':
    ensure          => installed,
    source          => "${temp_folder}/msodbcsql_v11.msi",
    install_options => ['ADDLOCAL=ALL', 'IACCEPTMSODBCSQLLICENSETERMS=YES'],
  }
  
  #-> archive { "${temp_folder}/MsSqlCmdLnUtils_v11.msi":
  #  source  => $sqlcmdutils_source,
  #}

  ::sqlserver::common::download_microsoft_file { 'MsSqlCmdLnUtils_v11.msi':
    source => $sqlcmdutils_source,
    destination => "${temp_folder}/MsSqlCmdLnUtils_v11.msi"
  }

  -> package { 'Microsoft Command Line Utilities 11 for SQL Server':
    ensure          => installed,
    source          => "${temp_folder}/MsSqlCmdLnUtils_v11.msi",
    install_options => ['IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES'],
  }
}
