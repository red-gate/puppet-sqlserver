# Install SSMS 19 Preview 2
class sqlserver::ssms::v19(
  $source = 'https://go.microsoft.com/fwlink/?linkid=2195969&clcid=0x409',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - 19.0 Preview 2',
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