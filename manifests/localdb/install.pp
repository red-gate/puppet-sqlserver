# Install a version of SQL LocalDB
#
# $source: the url to download SqlLocalDB from
# $version: the version as displayed in the installer name. (2012, 2014...)
define sqlserver::localdb::install(
  $source,
  $version,
  $tempFolder = 'c:/temp') {

  require chocolatey
  include archive

  $filename = inline_template('<%= File.basename(@source) %>')
  $folder = "${tempFolder}/localdb${version}"

  ensure_resource('file', [$tempFolder, $folder], { ensure => directory })

  archive { "${tempFolder}/localdb${version}/${filename}":
    source  => $source,
    require => File[$folder],
  }
  ->
  package { "Microsoft SQL Server ${version} Express LocalDB ":
    ensure          => installed,
    source          => "${folder}/${filename}",
    install_options => ['IACCEPTSQLLOCALDBLICENSETERMS=YES'],
  }
  ->
  windows_env { "SQLLOCALDB_VERSION=${version}": }
}
