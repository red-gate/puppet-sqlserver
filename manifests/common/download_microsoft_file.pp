# @summary Downloads a file using Powershell
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

  exec { "download file from Microsoft to ${destination}":
    provider  => 'powershell',
    command   => "Invoke-WebRequest -URI ${source} -Outfile ${destination}",
    onlyif    => "if (Test-Path ${destination}) { exit 1 } else { exit 0 }",
    logoutput => true,
  }
}
