# Install SQL Server 2016
#
# $source: path to to the SQL Server 2016 Iso file.
#     (can be a UNC share / URL)
#
# $programEntryName: the entry in Add/Remove Programs that is created when installing SQL Server.
#      This might change based on the version of the iso.
#
# $tempFolder: path to a local folder where the SQL Server iso will be downloaded/extracted.
#
# $instanceName: The name of the SQL Server instance.
#
# $version: the version that will be set as the value of the SQLSERVER_VERSION environment variable.
#   (used to keep track of what version is installed)
#
# $saPassword: The password for the sa account.
class sqlserver::v2016(
  $source,
  $programEntryName = 'Microsoft SQL Server 2016 RC0 (64-bit)',
  $tempFolder = 'c:/temp',
  $instanceName = 'SQL2016',
  $version     = '2016RC0',
  $saPassword) {

  include archive
  include ::sqlserver::reboot

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_notextension = inline_template('<%= File.basename(@source, ".*") %>')

  ensure_resource('file', $tempFolder, { ensure => directory })

  file { "${tempFolder}/${isofilename_notextension}":
    ensure  => directory,
    require => File[$tempFolder],
  }
  ->
  archive { "${tempFolder}/${isofilename}":
    source       => $source,
    extract      => true,
    extract_path => "${tempFolder}/${isofilename_notextension}",
    creates      => "${tempFolder}/${isofilename_notextension}/setup.exe",
    cleanup      => true,
  }
  ->
  package { $programEntryName:
    ensure          => installed,
    source          => "${tempFolder}/${isofilename_notextension}/setup.exe",
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
    require         => Reboot['reboot before installing SQL Server (if pending)'],
  }
  ~>
  reboot { 'reboot after installing SQL Server 2016': }
  ->
  windows_env { "SQLSERVER_VERSION=${version}": }

}
