# Install SQL Server 2012 EXPRESS.
#
# $setupexe: path to SQL Server en_sql_server_2012_express_edition_with_tools_x86.exe
#
# $instanceName: The name of the SQL Server instance.
#
# $saPassword: The password for the sa account.
#
class sqlserver::2012express(
  $setupexe,
  $instanceName = 'SQLEXPRESS',
  $saPassword) {

  package {'Microsoft SQL Server 2012':
    ensure          => installed,
    source          => $setupexe,
    install_options => [
      '/Q',
      '/IACCEPTSQLSERVERLICENSETERMS',
      '/ACTION=install',
      "/INSTANCENAME=${instanceName}",
      '/FEATURES=SQL,IS,Tools',
      '/SQLSYSADMINACCOUNTS=BUILTIN\Administrators',
      '/SQLSVCACCOUNT=NT AUTHORITY\SYSTEM',
      '/SECURITYMODE=SQL',
      "/SAPWD=\"${saPassword}\""],
    require         => Reboot['reboot before installing SQL Server (if pending)'],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2012EXPRESS': }
}
