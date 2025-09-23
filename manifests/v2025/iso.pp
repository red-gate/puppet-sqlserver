# @summary Download and extract a SQL Server 2022 iso.
#
# @param source
#   Source URL of the ISO 
class sqlserver::v2025::iso (
  String $source
) {
  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + "/setup.exe" %>')

  sqlserver::common::download_installer { $title:
    source  => $source,
  }
}
