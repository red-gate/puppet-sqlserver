# @summary Install SSMS 2017.5
#
# @param source
#   URL for SSMS
# @param filename
#   Filename of installer
# @param program_name
#   Name of the program as it appears in add/remove programs.
# @param temp_folder
#   path to temp folder
class sqlserver::ssms::v2017 (
  String $source = 'https://go.microsoft.com/fwlink/?linkid=867670',
  String $filename = 'SSMS-Setup-ENU.exe',
  String $program_name = 'Microsoft SQL Server Management Studio - 17.5',
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
