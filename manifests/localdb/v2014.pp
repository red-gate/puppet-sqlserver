# Install SQL LocalDB 2014
class sqlserver::localdb::v2014($tempFolder = 'c:/temp') {

  sqlserver::localdb::install { 'Install LocalDB 2014':
    source     => 'https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/LocalDB%2064BIT/SqlLocalDB.msi',
    version    => 2014,
    tempFolder => $tempFolder
  }

}
