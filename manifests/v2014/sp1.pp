# Download and extract SQL Server 2014 Sp1. (12.0.4100.1)
# SQL Server 2014 build versions: https://support.microsoft.com/en-gb/kb/2936603
class sqlserver::v2014::sp1(
  $source = 'https://download.microsoft.com/download/2/F/8/2F8F7165-BB21-4D1E-B5D8-3BD3CE73C77D/SQLServer2014SP1-KB3058865-x64-ENU.exe',
  $applies_to_version = '12.0.2000.8'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
