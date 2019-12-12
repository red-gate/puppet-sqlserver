# Download and extract SQL Server 2008R2 Sp3. (10.50.6000.34)
# SQL Server 2008R2 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2008r2::sp3(
  $source = 'https://download.microsoft.com/download/D/7/A/D7A28B6C-FCFE-4F70-A902-B109388E01E9/ENU/SQLServer2008R2SP3-KB2979597-x64-ENU.exe',
  $applies_to_version = '10.50.1600.1'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
