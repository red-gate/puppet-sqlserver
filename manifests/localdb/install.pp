# @sumamry Install a version of SQL LocalDB
#
# @param source
#    the url to download SqlLocalDB from
# @param version
#    the version as displayed in the installer name. (2012, 2014...)
# @param temp_folder
#   Location of the temp folder
define sqlserver::localdb::install (
  String $source,
  String $version,
  String $temp_folder = 'C:/Windows/Temp'
) {
  require chocolatey
  include archive

  $filename = inline_template('<%= File.basename(@source) %>')
  $folder = "${temp_folder}/localdb${version}"

  ensure_resource('file', $folder, { ensure => directory })

  #archive { "${temp_folder}/localdb${version}/${filename}":
  #  source  => $source,
  #  require => File[$folder],
  #}

  ::sqlserver::common::download_microsoft_file { $filename :
    source => $source,
    destination => "${temp_folder}/localdb${version}/${filename}",
    require => File[$folder],
  }

  -> package { "Microsoft SQL Server ${version} Express LocalDB ":
    ensure          => installed,
    source          => "${folder}/${filename}",
    install_options => ['IACCEPTSQLLOCALDBLICENSETERMS=YES'],
  }
  -> windows_env { "SQLLOCALDB_VERSION=${version}": }
}
