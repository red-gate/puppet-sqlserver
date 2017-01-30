# Install "Security Update for SQL Server 2014 Service Pack 2 GDR (KB3194714)"
# (https://www.microsoft.com/en-us/download/details.aspx?id=54190)
class sqlserver::v2014::kb3194714(
  $source = 'https://download.microsoft.com/download/A/4/4/A44A125B-5900-4877-891B-4FE497600419/SQL2014SP2GDR/x64/SQLServer2014-KB3194714-x64.exe',
  $applies_to_version = '12.2.5000.0'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
