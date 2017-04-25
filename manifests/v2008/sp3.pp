# Download and extract SQL Server 2008 Sp3. (10.3.5500.0)
# SQL Server 2008 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2008::sp3(
  $source = '',
  $applies_to_version = '10.0.1600.22'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
