# Install a patch / Service pack for a SQL Server instance.
#
# $installer_path: Full path to a setup.exe file.
#
# $applies_to_version: The current expected PatchLevel of the SQL Server instance this patch
#                      is going to be applied to.
#                      If the PatchLevel is different, than the patch is not applied.
#
# $instance_name: The name of the SQL Server instance to patch
define sqlserver::common::patch_sqlserver_instance(
  $installer_path,
  $applies_to_version,
  $instance_name = $title
  ) {

  # 0 + is needed so that $major_version is an int.
  # https://docs.puppet.com/puppet/latest/lang_data_number.html#converting-strings-to-numbers
  $major_version = 0 + $applies_to_version.match(/(\d+)\./)[1]

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL${major_version}.${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"

  case $major_version {
    11, 12: { $additional_parameters = '/IACCEPTSQLSERVERLICENSETERMS' }
    13: { $additional_parameters = '/IACCEPTSQLSERVERLICENSETERMS /IACCEPTROPENLICENSETERMS' }
    default: { $additional_parameters = '' }
  }

  exec { "${installer_path} : ${instance_name}":
    command => "\"${installer_path}\" \
/QUIET \
${additional_parameters} \
/ACTION=Patch \
/INSTANCENAME=${instance_name}",
    onlyif  => "cmd.exe /C reg query ${get_patchlevel_from_registry} | findstr ${applies_to_version}",
    require => [
      Exec["Install SQL Server instance: ${instance_name}"],
      Reboot["reboot before installing ${instance_name} Patch (if pending)"]
    ],
    returns => [0,3010],
    notify  => Reboot["Reboot after patching ${instance_name}"],
  }
}
