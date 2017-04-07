# Download and extract a SQL Server 2005 iso.
class sqlserver::v2005::iso($source) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/SQL Server " + @architecture + "/Servers/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
    creates => $installer,
  }
}
