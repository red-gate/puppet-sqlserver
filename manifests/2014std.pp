# Install SQL Server 2014 STD
#
# $setupexe: path to SQL Server setup.exe
#
# $instanceName: The name of the SQL Server instance.
#
# $saPassword: The password for the sa account.
class sqlserver::2014std(
  $setupexe,
  $instanceName = 'SQL2014',
  $saPassword) {

  package {'Microsoft SQL Server 2014 (64-bit)':
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
  windows_env { 'SQLSERVER_VERSION=2014STD': }
}
