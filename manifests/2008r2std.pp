# Install SQL Server 2008 R2 STD x64
#
# $setupexe: path to SQL Server setup.exe
#
# $instanceName: The name of the SQL Server instance to install.
#
# $saPassword: The password for the sa account.
#
class sqlserver::2008r2std(
  $setupexe,
  $instanceName = 'SQL2008R2',
  $saPassword) {

  package {'Microsoft SQL Server 2008 R2 (64-bit)':
    ensure          => installed,
    source          => $setupexe,
    install_options => [
      '/Q',
      '/ACTION=install',
      '/FEATURES=SQL,IS,Tools',
      "/INSTANCENAME=${instanceName}",
      '/SQLSYSADMINACCOUNTS=BUILTIN\Administrators',
      '/SQLSVCACCOUNT=NT AUTHORITY\SYSTEM',
      '/AGTSVCACCOUNT=NT AUTHORITY\SYSTEM',
      '/SECURITYMODE=SQL',
      "/SAPWD=\"${saPassword}\"",
      '/FILESTREAMLEVEL=2',
      "/FILESTREAMSHARENAME=${instanceName}"],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2008R2STD': }
}
