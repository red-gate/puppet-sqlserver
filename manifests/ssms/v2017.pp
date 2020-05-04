# Install SSMS 2017.5
class sqlserver::ssms::v2017(
  $source = 'https://go.microsoft.com/fwlink/?linkid=867670',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - 17.5',
  $tempFolder = 'C:/Windows/Temp',
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
