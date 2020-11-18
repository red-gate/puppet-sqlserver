# Download and extract SQL Server 2008 Sp3. (10.0.5500.0)
# SQL Server 2008 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2008::sp3(
  $source = 'https://download.microsoft.com/download/7/C/8/7C8F6A23-5876-4C55-91AD-5488360F8FD6/SQLServer2008SP3-KB2546951-x64-ENU.exe',
  $applies_to_version = '10.0.1600.22'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
