# Download and extract SQL Server 2008 Sp4. (10.4.6000.29)
# SQL Server 2008 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2008::sp4(
  $source = 'https://download.microsoft.com/download/5/E/7/5E7A89F7-C013-4090-901E-1A0F86B6A94C/ENU/SQLServer2008SP4-KB2979596-x64-ENU.exe',
  $applies_to_version = '10.0.1600.22'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
