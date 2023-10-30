# @summary Download and extract SQL Server 2008R2 Sp3 KB4057113.
#     SQL Server 2008R2 build versions: https://sqlserverbuilds.blogspot.co.uk/
#
# @param source
#   URL to the Patch installer
#
# @param applies_to_version
#   SQL version the patch applies to
class sqlserver::v2008r2::kb4057113 (
  String $source = 'https://download.microsoft.com/download/E/C/1/EC1EA99F-8738-442E-842B-0B483CE62C77/SQLServer2008R2-KB4057113-x64.exe',
  String $applies_to_version = '10.53.6000.34'
) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
  }
}
