# Install SQL Server 2016 CTP 2.4
#
# $setupexe: path to SQL Server setup.exe
#
# $instanceName: The name of the SQL Server instance.
#
# $saPassword: The password for the sa account.
class sqlserver::v2016ctp2_4(
  $setupexe,
  $instanceName = 'SQL2016',
  $saPassword) {

  package {'Microsoft SQL Server 2016 CTP2.4 (64-bit)':
    ensure          => installed,
    source          => $setupexe,
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
  windows_env { 'SQLSERVER_VERSION=2016CTP2.4': }
}
