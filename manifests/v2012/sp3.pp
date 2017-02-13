# Download and extract SQL Server 2012 Sp3. (11.3.6020.0)
# SQL Server 2012 build versions: https://support.microsoft.com/en-us/help/3133750/sql-server-2012-sp3-build-versions
class sqlserver::v2012::sp3(
  $source = 'https://download.microsoft.com/download/B/1/7/B17F8608-FA44-462D-A43B-00F94591540A/ENU/x64/SQLServer2012SP3-KB3072779-x64-ENU.exe',
  $applies_to_version = '11.00.3000'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
