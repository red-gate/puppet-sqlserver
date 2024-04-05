# @summary Download and extract SQL Server 2005 Sp4. (9.0.5000)
#   SQL Server 2005 build versions: https://sqlserverbuilds.blogspot.co.uk/
# 
# @param applies_to_version
#   SQL Version this patch applies to
class sqlserver::v2005::sp4 (
  String $applies_to_version = '9.00.1399.06'
) {
  if($facts['os']['architecture'] == 'x64') {
    $source = 'http://download.windowsupdate.com/msdownload/update/software/svpk/2011/01/sqlserver2005sp4-kb2463332-x64-enu_40c41a66693561adc22727697be96aeac8597f40.exe'
    $checksum = '40c41a66693561adc22727697be96aeac8597f40'
  } else {
    $source = 'http://download.windowsupdate.com/msdownload/update/software/svpk/2011/01/sqlserver2005sp4-kb2463332-x86-enu_bcca52a52c9a9b9a3fbb6ab9ea639e394eed2b64.exe'
    $checksum = 'bcca52a52c9a9b9a3fbb6ab9ea639e394eed2b64'
  }

  # $installer points to setup.exe
  $installer = inline_template('<%= "C:/Windows/Temp/" + File.basename(@source, ".*") + ".exe" %>')

  archive { $installer:
    source        => $source,
    checksum      => $checksum,
    checksum_type => 'sha1',
  }
}
