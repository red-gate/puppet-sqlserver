# Install SSMS 2016.
class sqlserver::ssms::v2016(
  $source = 'http://go.microsoft.com/fwlink/?LinkID=786460',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - April 2016',
  $tempFolder = 'c:/temp'
  ) {

  require archive
  require ::sqlserver::reboot

  ensure_resource('file', $tempFolder, { ensure => directory })

  archive { "${tempFolder}/${filename}":
    source  => $source,
    require => File[$tempFolder],
  }
  ->
  package { $programName:
    ensure          => installed,
    source          => "${tempFolder}/${filename}",
    install_options => ['/install', '/quiet', '/norestart'],
    require         => Reboot['reboot before installing SQL Server (if pending)'],
  }
}
