# Install SQL Server 2016
#
# $source: path to to the SQL Server 2016 Iso file.
#     (can be a UNC share / URL)
#
# $sa_password: The password for the sa account.
#
# $program_entry_name: the entry in Add/Remove Programs that is created when installing SQL Server.
#      This might change based on the version of the iso.
#
# $temp_folder: path to a local folder where the SQL Server iso will be downloaded/extracted.
#
# $instance_name: The name of the SQL Server instance.
#
# $version: the version that will be set as the value of the SQLSERVER_VERSION environment variable.
#   (used to keep track of what version is installed)
#
class sqlserver::v2016(
  $source,
  $sa_password,
  $program_entry_name = 'Microsoft SQL Server 2016 (64-bit)',
  $temp_folder        = 'c:/temp',
  $instance_name      = 'SQL2016',
  $version            = '2016RTM',
  $reboot_timeout     = 60) {

  require chocolatey
  include archive
  include ::sqlserver::reboot

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_notextension = inline_template('<%= File.basename(@source, ".*") %>')

  ensure_resource('file', $temp_folder, { ensure => directory })

  file { "${temp_folder}/${isofilename_notextension}":
    ensure  => directory,
    require => File[$temp_folder],
  }
  ->
  archive { "${temp_folder}/${isofilename}":
    source       => $source,
    extract      => true,
    extract_path => "${temp_folder}/${isofilename_notextension}",
    creates      => "${temp_folder}/${isofilename_notextension}/setup.exe",
    cleanup      => true,
  }
  ->
  package { $program_entry_name:
    ensure          => installed,
    source          => "${temp_folder}/${isofilename_notextension}/setup.exe",
    install_options => [
      '/Q',
      '/IACCEPTSQLSERVERLICENSETERMS',
      '/ACTION=install',
      '/FEATURES=SQL,IS,Tools',
      "/instance_name=${instance_name}",
      '/SQLSYSADMINACCOUNTS=BUILTIN\Administrators',
      '/SQLSVCACCOUNT=NT AUTHORITY\SYSTEM',
      '/SECURITYMODE=SQL',
      "/SAPWD=\"${sa_password}\"",
      '/FILESTREAMLEVEL=2',
      "/FILESTREAMSHARENAME=${instance_name}"],
    require         => Reboot['reboot before installing SQL Server (if pending)'],
  }
  ~>
  reboot { 'reboot after installing SQL Server 2016':
    timeout => $reboot_timeout,
  }
  ->
  windows_env { "SQLSERVER_VERSION=${version}": }

}
