# @summary Install SSMS 18.6
#
# @param source
#   URL for SSMS
# @param filename
#   Filename of installer
# @param program_name
#   Name of the program as it appears in add/remove programs.
# @param temp_folder
#   path to temp folder
class sqlserver::ssms::v2018 (
  String $source = 'https://download.microsoft.com/download/d/9/7/d9789173-aaa7-4f5b-91b0-a2a01f4ba3a6/SSMS-Setup-ENU.exe',
  String $filename = 'SSMS-Setup-ENU.exe',
  String $program_name = 'Microsoft SQL Server Management Studio - 18.6',
  String $temp_folder = 'C:/Windows/Temp',
) {
  include archive

  archive { "${temp_folder}/${filename}":
    source  => $source,
  }
  -> reboot { 'reboot before installing SSMS (if pending)':
    when => pending,
  }
  -> package { $program_name:
    ensure          => installed,
    source          => "${temp_folder}/${filename}",
    install_options => ['/install', '/quiet', '/norestart'],
  }
}
