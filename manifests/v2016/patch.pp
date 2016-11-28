# Download and extract a SQL Server 2016 patch.
class sqlserver::v2016::patch(
  $source = 'https://download.microsoft.com/download/3/0/D/30D3ECDD-AC0B-45B5-B8B9-C90E228BD3E5/ENU/SQLServer2016SP1-KB3182545-x64-ENU.exe',
  $version = '13.1.4001.0',
  $temp_folder = 'c:/temp'
  ) {

  require archive

  $filename = inline_template('<%= File.basename(@source) %>')
  $filename_noextension = inline_template('<%= File.basename(@source, ".*") %>')
  $installer = "${temp_folder}/${filename_noextension}/setup.exe"

  ensure_resource('file', $temp_folder, { ensure => directory })

  file { "${temp_folder}/${filename_noextension}":
    ensure  => directory,
    require => File[$temp_folder],
  }
  ->
  archive { "${temp_folder}/${filename}":
    source       => $source,
    extract      => true,
    extract_path => "${temp_folder}/${filename_noextension}",
    creates      => $installer,
    cleanup      => true,
  }

}
