# Install SSMS 2016.
class sqlserver::ssms::v2016(
  $source = 'http://go.microsoft.com/fwlink/?LinkID=828615',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - 16.4.1',
  $tempFolder = 'C:/Windows/Temp'
  ) {

  include archive

  archive { "${tempFolder}/${filename}":
    source  => $source,
  }
  -> reboot { 'reboot before installing SSMS (if pending)':
    when => pending,
  }
  -> package { $programName:
    ensure          => installed,
    source          => "${tempFolder}/${filename}",
    install_options => ['/install', '/quiet', '/norestart'],
  }
}
