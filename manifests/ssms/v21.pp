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
  String $source = 'https://aka.ms/ssms/21/release/vs_SSMS.exe',
  String $filename = 'vs_SSMS.exe',
  String $program_name = 'SQL Server Management Studio 21',
  String $temp_folder = 'C:/Windows/Temp',
) {
  include archive

  archive { "${temp_folder}/${filename}":
    source  => $source,
  }
  -> reboot { 'reboot before installing SSMS (if pending)':
    when => pending,
  }
  # Use an exec here instead of a Package resource because the new bootstrap installer is very eager to exit
  # which causes puppet to move on and reboot before the install has actually finished. 
  # By using `start-process` we can instruct it to wait for all child processes to complete.
  -> exec { "install ${program_name}":
    command => "Start-Process '${temp_folder}/${filename}' -wait -argumentlist '--quiet --norestart' -passThru ",
    provider => powershell,
    creates => 'C:/Program Files/Microsoft SQL Server Management Studio 21/Release/Common7/IDE/SSMS.exe',
  }
}
