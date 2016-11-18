# Install SQL Server 2016
#
# $source: path to to the SQL Server 2016 Iso file.
#     (can be a UNC share / URL)
#
# $sa_password: The password for the sa account.
#
# $install_type: 'RTM' or 'SP1'. Defaults to SP1
#
# $program_entry_name: the entry in Add/Remove Programs that is created when installing SQL Server.
#      This might change based on the version of the iso.
#
# $temp_folder: path to a local folder where the SQL Server iso will be downloaded/extracted.
#
# $instance_name: The name of the SQL Server instance.
#
class sqlserver::v2016(
  $source,
  $sa_password,
  $install_type       = 'SP1',
  $program_entry_name = 'Microsoft SQL Server 2016 (64-bit)',
  $temp_folder        = 'c:/temp',
  $instance_name      = 'SQL2016',
  $reboot_timeout     = 60) {

  require chocolatey
  include archive
  include ::sqlserver::reboot

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_notextension = inline_template('<%= File.basename(@source, ".*") %>')

  $sp1_url = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe'
  $sp1_filename = inline_template('<%= File.basename(@sp1_url) %>')

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

  case  $install_type {
    'SP1': {

      # Download SP1 installer
      archive { "${temp_folder}/${$sp1_filename}":
        source => $sp1_url,
      }

      $windows_env_require = Archive["${temp_folder}/${$sp1_filename}"]

    }
    'RTM': {
      $windows_env_require = Package[$program_entry_name]
    }
    default: {
      fail("Unsupported value for install_type: '${install_type}'")
    }
  }

  windows_env { "SQLSERVER_VERSION=2016${install_type}":
    require => $windows_env_require,
  }

}
