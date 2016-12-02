# Download and extract a SQL Server 2016 patch.
class sqlserver::v2016::patch(
  $source = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe',
  $version = '13.1.4001.0'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
