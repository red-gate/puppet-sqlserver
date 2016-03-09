# Install SQL Server 2008 STD x64
#
# $setupexe: path to SQL Server setup.exe
#
# $instanceName: The name of the SQL Server instance to install.
#
# $saPassword: The password for the sa account.
#
class sqlserver::2008std(
  $setupexe,
  $instanceName = 'SQL2008',
  $saPassword) {

  require ::sqlserver::reboot

  package {'Microsoft SQL Server 2008 (64-bit)':
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
    require         => Reboot['reboot before installing SQL Server (if pending)'],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2008STD': }
}
