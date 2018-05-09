# make sure that a localdb instance instance is created and is valid.
#
# localdb_instance_name: the name of the localdb instance to create
define sqlserver::localdb::instance($localdb_instance_name = 'v11.0') {

  Exec {
    # Use the latest sqllocaldb.exe that can be found.
    path => [
      'C:/Program Files/Microsoft SQL Server/140/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/130/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/120/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/110/Tools/Binn',
      'C:/Windows/system32', # Needed to find cmd.exe
    ]
  }

  # This command will delete $localdb_instance_name if it is not valid. (just to make sure the following create gets a chance to work)
  exec { "sqlserver::localdb::instance-delete-${localdb_instance_name}-if-invalid":
    command   => "sqllocaldb delete ${localdb_instance_name}",
    # puppet seems to need "cmd /C" for findstr to work properly...
    unless    => "cmd /C sqllocaldb info ${localdb_instance_name} | findstr /R \"Name:.*${localdb_instance_name}\"",
    logoutput => true,
  }
  # This command will create $localdb_instance_name if it does not exist
  -> exec { "sqlserver::localdb::instance-create-${localdb_instance_name}-if-missing":
    command   => "sqllocaldb create ${localdb_instance_name}",
    # puppet seems to need "cmd /C" for findstr to work properly...
    unless    => "cmd /C sqllocaldb info ${localdb_instance_name} | findstr /R \"Name:.*${localdb_instance_name}\"",
    logoutput => true,
  }

}
