# Download and extract a SQL Server 2008R2 iso.
class sqlserver::v2008r2::iso($source) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source => $source,
  }
}
