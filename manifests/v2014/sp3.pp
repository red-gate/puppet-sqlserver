# Download and extract SQL Server 2014 Sp3. 
class sqlserver::v2014::sp3 (
  String $source = 'https://download.microsoft.com/download/7/9/f/79f4584a-a957-436b-8534-3397f33790a6/SQLServer2014SP3-KB4022619-x64-ENU.exe',
  String $applies_to_version = '12.0.2000.8'
) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
  }
}
