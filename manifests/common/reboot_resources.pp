# @summary A list of reboot resources we use when installing and patching
#         SQL Server instances
#
# @param instance_name
#     Name of the SQL instance
#
define sqlserver::common::reboot_resources (
  String $instance_name = $title
) {
  reboot { "reboot before installing ${instance_name} (if pending)":
    when  => pending,
    apply => 'immediately',
  }
  reboot { "reboot before installing ${instance_name} Patch (if pending)":
    when  => pending,
    apply => 'immediately',
  }
  reboot { "Reboot after patching ${instance_name}":
    when    => 'pending',
    apply   => 'immediately',
    message => "Reboot after patching ${instance_name}",
  }
}
