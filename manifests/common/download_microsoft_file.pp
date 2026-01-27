# @summary Downloads a file using Powershell
# This exists due to the certificate chain issues with 'download.microsoft.com' which prevent the archive module from working
#
# @param source
#     URL where file is to be downloaded from
#
# @param destination
#     Local location to store downloaded file
#
define sqlserver::common::download_microsoft_file (
  String $source,
  String $destination
) {

  exec { "download file from Microsoft from ${source} to ${destination}":
    provider  => 'powershell',
    command   => "\$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -URI ${source} -Outfile ${destination}",
    unless    => "if (Test-Path ${destination}) { exit 0 } else { exit 1 }",
    logoutput => true,
  }
}

