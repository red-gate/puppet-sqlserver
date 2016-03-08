# Install SQL Server 2016 CTP 3.3
#
# $source: path to SQLServer2016CTP3.3-x64-ENU.iso
#     (can be a UNC share / URL)
#
# $tempFolder: path to a local folder where the SQL Server install files will be downloaded/extracted.
#
# $instanceName: The name of the SQL Server instance.
#
# $saPassword: The password for the sa account.
class sqlserver::2016ctp3_3(
  $source,
  $tempFolder = 'c:/temp',
  $instanceName = 'SQL2016',
  $saPassword) {

  class { 'sqlserver::2016':
    source           => "${source}/SQLServer2016CTP3.3-x64-ENU.iso",
    programEntryName => 'Microsoft SQL Server 2016 CTP3.3 (64-bit)',
    tempFolder       => $tempFolder,
    instanceName     => $instanceName,
    version          => '2016CTP3.3',
    saPassword       => $saPassword,
  }
  
}
