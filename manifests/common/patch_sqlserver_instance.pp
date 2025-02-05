# @summary Install a patch / Service pack for a SQL Server instance.
#
# @param installer_path
#    Full path to a setup.exe file.
#
# @param applies_to_version
#    The current expected PatchLevel of the SQL Server instance this patch
#     is going to be applied to.
#     If the PatchLevel is different, than the patch is not applied.
#
# @param instance_name
#    The name of the SQL Server instance to patch
define sqlserver::common::patch_sqlserver_instance (
  String $installer_path,
  String $applies_to_version,
  String $instance_name = $title
) {
  # https://www.puppet.com/docs/puppet/7/lang_data_number.html#lang_data_number_convert_strings
  $major_version = Integer($applies_to_version.match(/(\d+)\./)[1])
  $minor = Integer($applies_to_version.match(/(\d+)\.(\d+)\./)[2])

  # Minor version for SQL2008R2 ranges from 50 to 53, depending on Service Pack
  if($minor >= 50 and $minor <= 53) {
    $version_path_component = "${major_version}_50" # Always seems to be '50' in registry path though. 
  }
  else {
    $version_path_component = $major_version
  }

  $registry_instance_path = "SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL${version_path_component}.${instance_name}"
  $get_patchlevel_from_registry = "\"HKLM\\${registry_instance_path}\\Setup\" /v PatchLevel"

  case $major_version {
    10: { if($minor >= 50 and $minor <= 53) { $additional_parameters = '/IACCEPTSQLSERVERLICENSETERMS' } }
    11, 12: { $additional_parameters = '/IACCEPTSQLSERVERLICENSETERMS' }
    13: { $additional_parameters = '/IACCEPTSQLSERVERLICENSETERMS /IACCEPTROPENLICENSETERMS' }
    default: { $additional_parameters = '' }
  }

  if(($facts['sqlserver_instances'][$instance_name]) and ($facts['sqlserver_instances'][$instance_name]['patch_level'] == $applies_to_version)) {
    # If we're going to do the patch, then trigger a reboot if one is pending before doing the actual install
    # If we're not going to do the patch, then don't trigger a reboot. This helps avoid doing reboots
    # when we don't need to (e.g. if a Windows Update requires a reboot).
    reboot { "reboot before installing ${instance_name} version ${applies_to_version} Patch (if pending)":
      when  => pending,
      apply => 'immediately',
      before => Exec["${installer_path} : ${instance_name}"],
    }
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
    ],
    notify => Reboot["Reboot after patching ${instance_name} version ${applies_to_version}"],
    returns => [0,3010],
  }

  reboot { "Reboot after patching ${instance_name} version ${applies_to_version}":
    when    => 'refreshed',
    apply   => 'immediately',
    message => "Reboot after patching ${instance_name} version ${applies_to_version}",
  }
}
