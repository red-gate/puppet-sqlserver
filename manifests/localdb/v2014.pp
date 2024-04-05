# @summary Install SQL LocalDB 2014
#
# @param temp_folder
#   location of a temp folder
class sqlserver::localdb::v2014 (
  String $temp_folder = 'C:/Windows/Temp'
) {
  sqlserver::localdb::install { 'Install LocalDB 2014':
    source     => 'https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/LocalDB%2064BIT/SqlLocalDB.msi',
    version    => '2014',
    temp_folder => $temp_folder,
  }
  # make sure that the MSSQLLocalDB auto instance is created and is valid.
  -> sqlserver::localdb::instance { 'Create MSSQLLocalDB':
    localdb_instance_name => 'MSSQLLocalDB',
  }
}
