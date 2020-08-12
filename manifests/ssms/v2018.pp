# Install SSMS 18.6
class sqlserver::ssms::v2018(
  $source = 'https://download.microsoft.com/download/d/9/7/d9789173-aaa7-4f5b-91b0-a2a01f4ba3a6/SSMS-Setup-ENU.exe',
  $filename = 'SSMS-Setup-ENU.exe',
  $programName = 'Microsoft SQL Server Management Studio - 18.6',
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
