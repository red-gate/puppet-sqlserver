# Download and extract a SQL Server 2000 iso.
class sqlserver::v2000::iso($source) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/" + @architecture + "/setup/setupsql.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
    creates => $installer,
  }
}
