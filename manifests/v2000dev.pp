# Install SQL Server 2000 Developer edition
#
# $source: path to a folder / UNC share / http server containing:
#   en_sql_2000_dev.iso
#   en_sql2000_sp3a.iso
#
# $tempFolder: path to a local folder where the SQL Server install files will be downloaded/extracted.
#
# $instanceName: The name of the SQL Server instance to install.
#
# $saEncryptedPassword: The password for the sa account that will be injected in the InstallShield silent install answer file AS IS.
#                       How to generate that encrypted value is left as an exercise for the reader
#
class sqlserver::v2000dev(
  $source,
  $tempFolder = 'c:/temp',
  $instanceName = 'SQL2000',
  $saEncryptedPassword) {

  if( $::architecture != 'x86' ) {
    fail("SQL Server 2000 cannot be installed on ${::architecture} architecture")
  }

  include archive

  if (!defined(File[$tempFolder]))
  {
    file { $tempFolder:
      ensure   => directory,
    }
  }

  file { "${tempFolder}/sql2000":
    ensure  => 'directory',
    require => File[$tempFolder],
  }
  ->
  file { "${tempFolder}/sql2000/rtm":
    ensure  => 'directory',
  }
  ->
  file { "${tempFolder}/sql2000/sp3a":
    ensure => 'directory',
  }
  ->
  file {"${tempFolder}/sql2000/setup.iss":
    ensure             => 'present',
    content            => template('sqlserver/2000dev.iss.erb'),
    source_permissions => ignore,
  }
  ->
  archive { "${tempFolder}/sql2000/en_sql_2000_dev.iso":
    source       => "${source}/en_sql_2000_dev.iso",
    extract      => true,
    extract_path => "${tempFolder}/sql2000/rtm",
    creates      => "${tempFolder}/sql2000/rtm/x86/setup/setupsql.exe",
    cleanup      => true,
  }
  ->
  package { "Microsoft SQL Server 2000 (${instanceName})" :
    ensure          => installed,
    source          => "${tempFolder}/sql2000/rtm/x86/setup/setupsql.exe",
    install_options => ['-s','-f1',"${tempFolder}\\sql2000\\setup.iss", '-f2', "${tempFolder}\\sql2000\\install.rtm.log.txt"],
  }
  ->
  archive { "${tempFolder}/sql2000/en_sql2000_sp3a.iso":
    source       => "${source}/en_sql2000_sp3a.iso",
    extract      => true,
    extract_path => "${tempFolder}/sql2000/sp3a",
    creates      => "${tempFolder}/sql2000/sp3a/x86/setup/setupsql.exe",
    cleanup      => true,
  }
  ->
  file {"${tempFolder}/sql2000/sp3a.iss":
    ensure             => 'present',
    content            => template('sqlserver/2000sp3a.iss.erb'),
    source_permissions => ignore,
  }
  ->
  exec { "${instanceName} SP3a":
    command   => "${tempFolder}/sql2000/sp3a/x86/setup/setupsql.exe -s -f1 ${tempFolder}\\sql2000\\sp3a.iss -f2 ${tempFolder}\\sql2000\\install.sp3a.log.txt",
    logoutput => true,
    timeout   => 1800,
    path      => 'C:\Windows\System32',
    unless    => "cmd.exe /c reg.exe query \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\${instanceName}\\MSSQLSERVER\\CurrentVersion\" | findstr.exe 8.00.761",
    notify    => Reboot["SQL Server 2000 (${instanceName}) Reboot"],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2000Dev': }
  ->
  # Start all the services!
  # Note that the SQL Server service needs to be running before trying to apply SP3a.
  # That's probably because SP3A is running SQL Scripts against the system databases...
  service { "MSSQL$${instanceName}":
    ensure => 'running',
    enable => true,
  }

  reboot { "SQL Server 2000 (${instanceName}) Reboot": }
}
