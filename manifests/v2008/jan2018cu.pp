# Download and extract SQL Server 2008 Jan 2018 Cumulative Update. (10.0.6547.0)
# SQL Server 2008 build versions: https://sqlserverbuilds.blogspot.co.uk/
class sqlserver::v2008::jan2018cu(
  $source = 'https://download.microsoft.com/download/7/B/5/7B5E5ED1-0976-497D-B691-ED0D7311C4B8/SQLServer2008-KB4057114-x64.exe',
  $applies_to_version = '10.0.1600.22'
  ) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source
  }
}
