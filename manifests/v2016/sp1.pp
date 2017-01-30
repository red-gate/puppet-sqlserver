# Download and extract SQL Server 2016 Sp1. (13.1.4001.0)
# SQL Server 2016 build versions: https://support.microsoft.com/en-us/help/3177312/sql-server-2016-build-versions
class sqlserver::v2016::sp1(
  $source = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe',
  $applies_to_version = '13.0.1601.5'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
