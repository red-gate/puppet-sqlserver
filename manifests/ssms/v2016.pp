# @summary Install SSMS 2016.
#
# @param source
#   URL for SSMS
# @param filename
#   Filename of installer
# @param program_name
#   Name of the program as it appears in add/remove programs.
# @param temp_folder
#   path to temp folder
class sqlserver::ssms::v2016 (
  String $source = 'http://go.microsoft.com/fwlink/?LinkID=828615',
  String $filename = 'SSMS-Setup-ENU.exe',
  String $program_name = 'Microsoft SQL Server Management Studio - 16.4.1',
  String $temp_folder = 'C:/Windows/Temp'
) {
  include archive

  # archive { "${temp_folder}/${filename}":
  #  source  => $source,
  # }

  ::sqlserver::common::download_microsoft_file { "${temp_folder}/${filename}":
    source => $source,
    destination => "${temp_folder}/${filename}"
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
