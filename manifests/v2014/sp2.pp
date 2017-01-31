# Download and extract SQL Server 2014 Sp2. (12.2.5000.0)
# SQL Server 2014 build versions: https://support.microsoft.com/en-gb/kb/2936603
class sqlserver::v2014::sp2(
  $source = 'https://download.microsoft.com/download/6/D/9/6D90C751-6FA3-4A78-A78E-D11E1C254700/SQLServer2014SP2-KB3171021-x64-ENU.exe',
  $applies_to_version = '12.0.2000.8'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
