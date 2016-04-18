# Install SQL LocalDB 2012
class sqlserver::localdb::v2012($tempFolder = 'c:/temp') {

  sqlserver::localdb::install { 'Install LocalDB 2012':
    source     => 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SqlLocalDB.MSI',
    version    => 2012,
    tempFolder => $tempFolder
  }

}
