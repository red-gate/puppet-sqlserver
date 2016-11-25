# Download and extract files required to install
# SQL Server 2016
class sqlserver::v2016::resources(
  $source,
  $install_type = 'SP1',
  $temp_folder = 'c:/temp') {

  require archive

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_notextension = inline_template('<%= File.basename(@source, ".*") %>')

  $sp1_url = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe'
  $sp1_patch_version = '13.0.4001.0'
  $sp1_filename = inline_template('<%= File.basename(@sp1_url) %>')
  $sp1_filename_noextension = inline_template('<%= File.basename(@sp1_url, ".*") %>')

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

  if $install_type == 'SP1' {
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
  }
}
