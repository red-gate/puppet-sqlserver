# Install SQL Server 2005 STD
#
# $source: path to a folder / UNC share / http containing:
#   en_sql_2005_std_x64_dvd.iso
#   en_sql_2005_std_x86_dvd.iso
#   en_sql_server_2005_service_pack_4_x64.exe
#   en_sql_server_2005_service_pack_4_x86.exe
#
# $tempFolder: path to a local folder where the SQL Server install files will be downloaded/extracted.
#
# $instanceName: The name of the SQL Server instance to install.
#
# $saPassword: The password for the sa account.
#
class sqlserver::v2005std(
    $source,
    $tempFolder = 'c:/temp',
    $instanceName = 'SQL2005',
    $saPassword) {

  require chocolatey
  include archive

  if (!defined(File[$tempFolder]))
  {
    file { $tempFolder:
      ensure   => directory,
    }
  }

  if( $::architecture == 'x64' ) {
    $sqlProgramName = 'Microsoft SQL Server 2005 (64-bit)'
  } else {
    $sqlProgramName = 'Microsoft SQL Server 2005'
  }

  file {"${tempFolder}/${instanceName}.ini":
    ensure             => 'present',
    content            => template('sqlserver/2005std.ini.erb'),
    source_permissions => ignore,
    require            => File[$tempFolder],
  }
  ->
  file { "${tempFolder}/en_sql_2005_std_${::architecture}_dvd":
    ensure => 'directory',
  }
  ->
  archive { "${tempFolder}/en_sql_2005_std_${::architecture}_dvd.iso":
    source       => "${source}/en_sql_2005_std_${::architecture}_dvd.iso",
    extract      => true,
    extract_path => "${tempFolder}/en_sql_2005_std_${::architecture}_dvd",
    creates      => "${tempFolder}/en_sql_2005_std_${::architecture}_dvd/Servers/setup.exe",
    cleanup      => true,
  }
  ->
  package { $sqlProgramName :
    ensure          => installed,
    source          => "${tempFolder}/en_sql_2005_std_${::architecture}_dvd/Servers/setup.exe",
    install_options => ['/qn','/settings',"${tempFolder}\\${instanceName}.ini"],
  }
  ->
  archive { "${tempFolder}/en_sql_server_2005_service_pack_4_${::architecture}.exe":
    source => "${source}/en_sql_server_2005_service_pack_4_${::architecture}.exe",
  }
  ->
  exec { "${instanceName} SP4":
    command   => "${tempFolder}/en_sql_server_2005_service_pack_4_${::architecture}.exe /quiet /instancename=${instanceName} /sapwd=${saPassword}",
    logoutput => true,
    returns   => ['0', '3010'],
    timeout   => 1800,
    path      => 'C:\Windows\System32',
    unless    => "cmd.exe /c reg.exe query \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\${instanceName}\\MSSQLSERVER\\CurrentVersion\" | findstr.exe 9.00.5000",
    notify    => Reboot["SQL Server 2005 (${instanceName}) Reboot"],
  }
  ->
  windows_env { 'SQLSERVER_VERSION=2005STD': }
  ->
  # Start all the services!
  service { "MSSQL$${instanceName}":
    ensure => 'running',
    enable => true,
  }
  ->
  service { "SQLAgent$${instanceName}":
    ensure => 'running',
    enable => true,
  }
  ->
  service { "MSOLAP$${instanceName}":
    ensure => 'running',
    enable => true,
  }
  ->
  service { "msftesql$${instanceName}":
    ensure => 'running',
    enable => true,
  }

  reboot { "SQL Server 2005 (${instanceName}) Reboot": }
}
