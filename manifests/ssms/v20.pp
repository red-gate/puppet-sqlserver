# @summary Install SSMS 20.0
#
# @param source
#   URL for SSMS
# @param filename
#   Filename of installer
# @param program_name
#   Name of the program as it appears in add/remove programs.
# @param temp_folder
#   path to temp folder
class sqlserver::ssms::v20 (
  String $source = 'https://download.microsoft.com/download/1/b/c/1bc1f462-ac3a-402d-b872-c4cae745c539/SSMS-Setup-ENU.exe',
  String $filename = 'SSMS-Setup-ENU.exe',
  String $program_name = 'Microsoft SQL Server Management Studio - 20.0',
  String $temp_folder = 'C:/Windows/Temp',
) {
  include archive

  archive { "${temp_folder}/${filename}":
    source  => $source,
    allow_insecure => true
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
