# Install sqlcmd.exe
class sqlserver::sqlcmd::install::v10($temp_folder = 'C:/Windows/Temp') {

  include archive

  if $::architecture == 'x86' {
    $nativeclient_source = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/sqlncli.msi'
    $sqlcmdutils_source = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x86/SqlCmdLnUtils.msi'
  } else {
    $nativeclient_source = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/sqlncli.msi'
    $sqlcmdutils_source = 'http://download.microsoft.com/download/B/6/3/B63CAC7F-44BB-41FA-92A3-CBF71360F022/1033/x64/SqlCmdLnUtils.msi'
  }

  archive { "${temp_folder}/sqlncli_v10.msi":
    source  => $nativeclient_source,
  }
  -> package { 'Microsoft SQL Server 2008 R2 Native Client':
    ensure          => installed,
    source          => "${temp_folder}/sqlncli_v10.msi",
    install_options => ['ADDLOCAL=ALL', 'IACCEPTSQLNCLILICENSETERMS=YES'],
  }
  -> archive { "${temp_folder}/MsSqlCmdLnUtils_v10.msi":
    source  => $sqlcmdutils_source,
  }
  -> package { 'Microsoft SQL Server 2008 R2 Command Line Utilities':
    ensure          => installed,
    source          => "${temp_folder}/MsSqlCmdLnUtils_v10.msi",
    install_options => ['IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES'],
  }
}
