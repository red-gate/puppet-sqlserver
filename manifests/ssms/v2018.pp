# Install SSMS 18.3
class sqlserver::ssms::v2018(
  $source = 'https://go.microsoft.com/fwlink/?linkid=2105412',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - 18.3',
  $tempFolder = 'c:/temp'
  ) {

  include archive

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
