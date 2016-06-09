# Install SSMS 2016.
class sqlserver::ssms::v2016(
  $source = 'http://go.microsoft.com/fwlink/?LinkID=799832',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - June 2016',
  $tempFolder = 'c:/temp'
  ) {

  require archive

  ensure_resource('file', $tempFolder, { ensure => directory })

  archive { "${tempFolder}/${filename}":
    source  => $source,
    require => File[$tempFolder],
  }
  ->
  reboot { 'reboot before installing SSMS (if pending)':
    when => pending,
  }
  ->
  package { $programName:
    ensure          => installed,
    source          => "${tempFolder}/${filename}",
    install_options => ['/install', '/quiet', '/norestart'],
  }
}
