# Download and extract SQL Server 2012 Sp4 .
class sqlserver::v2012::sp4 (
  String $source = 'https://download.microsoft.com/download/e/a/b/eabf1e75-54f0-42bb-b0ee-58e837b7a17f/SQLServer2012SP4-KB4018073-x64-ENU.exe',
  String $applies_to_version = '11.0.2100'
) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
  }
}
