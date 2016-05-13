# Define a resource that will reboot the machine if a pending reboot is detected.
# Needed to make sure SQL Server installs do not fail because pending reboots are detected.
class sqlserver::reboot {
  reboot { 'reboot before installing SQL Server (if pending)':
    when => pending,
  }
}
