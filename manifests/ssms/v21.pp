# @summary Install SSMS 21 preview
#
# @param source
#   URL for SSMS
# @param filename
#   Filename of installer
# @param program_name
#   Name of the program as it appears in add/remove programs.
# @param temp_folder
#   path to temp folder
class sqlserver::ssms::v21 (
  String $source = 'https://aka.ms/ssms/21/preview/vs_SSMS.exe',
  String $filename = 'vs_SSMS.exe',
  String $program_name = 'Microsoft SQL Server Management Studio - 20.0',
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
    install_options => ['--quiet', '--norestart'],
  }
}
