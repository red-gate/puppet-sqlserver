# Download and extract a SQL Server 2016 iso.
class sqlserver::v2016::iso(
  $source,
  $temp_folder = 'c:/temp'
  ) {

  require archive

  $isofilename = inline_template('<%= File.basename(@source) %>')
  $isofilename_noextension = inline_template('<%= File.basename(@source, ".*") %>')
  $installer = "${temp_folder}/${isofilename_noextension}/setup.exe"

  ensure_resource('file', $temp_folder, { ensure => directory })

  file { "${temp_folder}/${isofilename_noextension}":
    ensure  => directory,
    require => File[$temp_folder],
  }
  ->
  archive { "${temp_folder}/${isofilename}":
    source       => $source,
    extract      => true,
    extract_path => "${temp_folder}/${isofilename_noextension}",
    creates      => $installer,
    cleanup      => true,
  }



}
