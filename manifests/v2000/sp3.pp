# Download and extract SQL Server 2000 Sp3. (8.00.761)
# SQL Server 2000 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2000::sp3(
  $source,
  $version = '8.00.761') {

  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/" + @architecture + "/setup/setupsql.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
    creates => $installer,
  }

}
