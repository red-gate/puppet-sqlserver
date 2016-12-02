define sqlserver::common::patch_sqlserver_instance(
  $installer_path,
  $patch_version,
  $instance_name = $title
  ) {

  $major_version = $patch_version.match(/(\d+)\./)[1]

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL${major_version}.${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"

  exec { "Install SQL Server Patch instance: ${instance_name}":
    command => "\"${installer_path}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
/IACCEPTROPENLICENSETERMS \
/ACTION=Patch \
/INSTANCENAME=${instance_name}",
    unless  => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${patch_version}",
    require => [
      Exec["Install SQL Server instance: ${instance_name}"],
      Reboot["reboot before installing ${instance_name} Patch (if pending)"]
    ],
    returns => [0,3010],
    notify  => Reboot["reboot after installing ${instance_name} Patch (if pending)"],
  }
}
