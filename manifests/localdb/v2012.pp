# @summary Install SQL LocalDB 2012
#
# @param temp_folder
#   Location of a temp folder
class sqlserver::localdb::v2012 (
  String $temp_folder = 'C:/Windows/Temp'
) {
  sqlserver::localdb::install { 'Install LocalDB 2012':
    source     => 'https://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SqlLocalDB.MSI',
    version    => 2012,
    temp_folder => $temp_folder,
  }
  # make sure that the v11.0 auto instance is created and is valid.
  -> sqlserver::localdb::instance { 'Create v11.0':
    localdb_instance_name => 'v11.0',
  }
}
