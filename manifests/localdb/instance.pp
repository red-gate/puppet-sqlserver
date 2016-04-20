# make sure that a localdb instance instance is created and is valid.
#
# localdb_sql_version: the SQL Server version of localdb. (110, 120)
# localdb_instance_name: the name of the localdb instance to create
define sqlserver::localdb::instance($localdb_sql_version = '110', $localdb_instance_name = 'v11.0') {

  Exec {
    path     => "C:/Program Files/Microsoft SQL Server/${localdb_sql_version}/Tools/Binn",
    provider => 'powershell',
  }

  # This command will delete $localdb_instance_name if it is not valid.
  exec { "sqlserver::localdb::instance-delete-${localdb_instance_name}-if-invalid":
    command => "sqllocaldb delete ${localdb_instance_name}",
    onlyif  => "if((sqllocaldb info ${localdb_instance_name}) -like 'Name:*${localdb_instance_name}') { exit 1 }",
  }
  ->
  # This command will create $localdb_instance_name if it does not exist
  exec { "sqlserver::localdb::instance-create-${localdb_instance_name}-if-missing":
    command => "sqllocaldb create ${localdb_instance_name}",
    unless  => "if((sqllocaldb info ${localdb_instance_name}) -like '*\"${localdb_instance_name}\" is not created.') { exit 1 }",
  }

}
