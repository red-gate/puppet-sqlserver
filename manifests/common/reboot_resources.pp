# A list of reboot resources we use when installing and patching
# SQL Server instances
define sqlserver::common::reboot_resources($instance_name = $title){
  reboot { "reboot before installing ${instance_name} (if pending)":
    when => pending,
  }
  reboot { "reboot before installing ${instance_name} Patch (if pending)":
    when => pending,
  }
}
