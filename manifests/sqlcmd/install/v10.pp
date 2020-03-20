# Install sqlcmd.exe
class sqlserver::sqlcmd::install::v10($temp_folder = 'C:/Windows/Temp') {

  include archive

  if $::architecture == 'x86' {
    $nativeclient_source = 'https://download.microsoft.com/download/2/4/F/24FE862D-7D32-47F2-B91D-22DAFA270BBC/2008%20R2%20ENU-1033/x86/sqlncli.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/9/2/7/927B0C39-C3E2-4CFC-B84E-92BC63344C62/ENU/x86/SqlCmdLnUtils.msi'
  } else {
    $nativeclient_source = 'https://download.microsoft.com/download/2/4/F/24FE862D-7D32-47F2-B91D-22DAFA270BBC/2008%20R2%20ENU-1033/x64/sqlncli.msi'
    $sqlcmdutils_source = 'https://download.microsoft.com/download/9/2/7/927B0C39-C3E2-4CFC-B84E-92BC63344C62/ENU/x64/SqlCmdLnUtils.msi'
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
