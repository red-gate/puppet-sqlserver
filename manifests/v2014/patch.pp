# Download and extract a SQL Server 2014 patch.
class sqlserver::v2014::patch(
  $source = 'TODO',
  $version = '13.1.4001.0'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
