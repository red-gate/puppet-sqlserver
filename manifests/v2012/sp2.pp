# Download and extract SQL Server 2012 Sp3. (11.2.5058.0)
# https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2012::sp2(
  $source = 'https://download.microsoft.com/download/D/F/7/DF7BEBF9-AA4D-4CFE-B5AE-5C9129D37EFD/SQLServer2012SP2-KB2958429-x64-ENU.exe',
  $applies_to_version = '11.00.3000'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
