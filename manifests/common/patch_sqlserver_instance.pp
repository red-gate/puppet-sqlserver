# Install a patch / Service pack for a SQL Server instance.
define sqlserver::common::patch_sqlserver_instance(
  $installer_path,
  $patch_version,
  $instance_name = $title
  ) {

  # 0 + is needed so that $major_version is an int.
  # https://docs.puppet.com/puppet/latest/lang_data_number.html#converting-strings-to-numbers
  $major_version = 0 + $patch_version.match(/(\d+)\./)[1]

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL${major_version}.${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"

  if $major_version > 12 {
    $additional_parameters = '/IACCEPTROPENLICENSETERMS'
  } else {
    $additional_parameters = ''
  }

  exec { "Install SQL Server Patch instance: ${instance_name}":
    command => "\"${installer_path}\" \
/QUIET \
/IACCEPTSQLSERVERLICENSETERMS \
${additional_parameters} \
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