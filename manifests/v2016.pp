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
  $install_type              = 'SP1',
  $program_entry_name        = 'Microsoft SQL Server 2016 (64-bit)',
  $temp_folder               = 'c:/temp',
  $instance_name             = 'SQL2016',
  $data_drive                = 'D',
  $log_drive                 = 'D',
  $backup_directory          = 'D:\Backups',
  $sql_collation             = 'Latin1_General_CI_AS',
  $sqlserver_service_account = '',
  $reboot_timeout            = 60) {

  require chocolatey
  include archive
  include ::sqlserver::reboot

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_notextension = inline_template('<%= File.basename(@source, ".*") %>')

  $sp1_url = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe'
  $sp1_filename = inline_template('<%= File.basename(@sp1_url) %>')
  $sp1_filename_noextension = inline_template('<%= File.basename(@sp1_url, ".*") %>')

  $instance_folder = $instance_name ? {
    'MSSQLSERVER' => 'MSSQL',
    default       => "MSSQL-${instance_name}",
  }

  $sqlsvcaccount = $sqlserver_service_account ? {
    ''      => "NT Service\\${instance_name}",
    defualt => $sqlserver_service_account,
  }

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
      "/INSTANCENAME=${instance_name}",
      "/SQLCOLLATION=${sql_collation}",
      '/SQLSYSADMINACCOUNTS=BUILTIN\Administrators',
      "/SQLSVCACCOUNT=\"${sqlsvcaccount}\"",
      '/AGTSVCSTARTUPTYPE=Automatic',
      '/SQLSVCINSTANTFILEINIT=True',
      '/SECURITYMODE=SQL',
      "/SAPWD=\"${sa_password}\"",
      "/INSTALLSHAREDDIR=\"${data_drive}:\\Program Files\\Microsoft SQL Server\"",
      "/INSTALLSHAREDWOWDIR=\"${data_drive}:\\Program Files (x86)\\Microsoft SQL Server\"",
      "/INSTALLSQLDATADIR=\"${data_drive}:\\Program Files\\Microsoft SQL Server\"",
      "/INSTANCEDIR=\"${data_drive}:\\Program Files\\Microsoft SQL Server\"",
      "/SQLUSERDBDIR=\"${data_drive}:\\${instance_folder}\\Data\"",
      "/SQLUSERDBLOGDIR=\"${log_drive}:\\${instance_folder}\\Log\"",
      "/SQLBACKUPDIR=\"${backup_directory}\"",
      "/SQLTEMPDBDIR=\"${data_drive}:\\${instance_folder}\\Data\"",
      "/SQLTEMPDBLOGDIR=\"${log_drive}:\\${instance_folder}\\Log\"",
      '/SQLTEMPDBFILESIZE=1024',
      '/SQLTEMPDBFILEGROWTH=1024',
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

      file { "${temp_folder}/${sp1_filename_noextension}":
        ensure  => directory,
        require => File[$temp_folder],
      }
      ->
      # Download SP1 installer
      archive { "${temp_folder}/${$sp1_filename}":
        source       => $sp1_url,
        extract      => true,
        extract_path => "${temp_folder}/${sp1_filename_noextension}",
        creates      => "${temp_folder}/${sp1_filename_noextension}/setup.exe",
        cleanup      => true,
      }
      ->
      # This package is hidden from the Add/Remove Programs view,
      # but this feels like our best bet to guess whether SP1 is already installed or not.
      # (RTM would be v13.0.XXX while SP1 is v13.1.4001.0)
      package { 'SQL Server 2016 Database Engine Services':
        ensure          => '13.1.4001.0',
        source          => "${temp_folder}/${sp1_filename_noextension}/setup.exe",
        install_options => [
          '/QUIET',
          '/IACCEPTSQLSERVERLICENSETERMS',
          '/IACCEPTROPENLICENSETERMS',
          '/ACTION=Patch',
          "/INSTANCENAME=${instance_name}"],
      }
      ~>
      reboot { 'reboot after installing SQL Server 2016 SP1':
        timeout => $reboot_timeout,
      }

      $windows_env_require = Package['SQL Server 2016 Database Engine Services']

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
