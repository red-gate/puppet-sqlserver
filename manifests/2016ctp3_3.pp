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

  include archive

  ensure_resource('file', $tempFolder, { ensure => directory })

  file { "${tempFolder}/SQLServer2016CTP3.3-x64-ENU":
    ensure  => directory,
    require => File[$tempFolder],
  }
  ->
  archive { "${tempFolder}/SQLServer2016CTP3.3-x64-ENU.iso":
    source       => $source,
    extract      => true,
    extract_path => "${tempFolder}/SQLServer2016CTP3.3-x64-ENU",
    creates      => "${tempFolder}/SQLServer2016CTP3.3-x64-ENU/setup.exe",
    cleanup      => true,
  }
  ->
  package {'Microsoft SQL Server 2016 CTP3.3 (64-bit)':
    ensure          => installed,
    source          => "${tempFolder}/SQLServer2016CTP3.3-x64-ENU/setup.exe",
    install_options => [
      '/Q',
      '/IACCEPTSQLSERVERLICENSETERMS',
      '/ACTION=install',
      '/FEATURES=SQL,IS,Tools',
      "/INSTANCENAME=${instanceName}",
      '/SQLSYSADMINACCOUNTS=BUILTIN\Administrators',
      '/SQLSVCACCOUNT=NT AUTHORITY\SYSTEM',
      '/SECURITYMODE=SQL',
      "/SAPWD=\"${saPassword}\"",
      '/FILESTREAMLEVEL=2',
      "/FILESTREAMSHARENAME=${instanceName}"],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2016CTP3.3': }
}
