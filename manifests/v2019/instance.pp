# Install an configure a single SQL Server 2019 Instance.
#
# $install_type:
#   'RTM' (don't patch)
#   or
#   'Patch' (install the latest Service Pack/Patch we are aware of.)
#     The patch installed can be customized by using the ::sqlserver::v2019::patch class.
#
define sqlserver::v2019::instance(
  $instance_name  = $title,
  $install_type   = 'Patch',
  $install_params = {
    features              => 'SQL,Tools,PolyBase',
    pbscaleout            => 'true',
    pbportrange           => '16450-16460',
    pbengsvcaccount       => 'BUILTIN\\Administrators',
    pbengsvcpassword      => 'YouBetterChangeThis!',
    pbdmssvcaccount       => 'BUILTIN\\Administrators',
    pbdmssvcpassword      => 'YouBetterChangeThis!',
  },
  $tcp_port       = 0
  ) {

  require ::sqlserver::v2019::iso

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  sqlserver::common::install_sqlserver_instance { $instance_name:
    installer_path => $::sqlserver::v2019::iso::installer,
    install_params => $install_params,
  }

# Patch is not yet supported for SQL Server 2019, so do just act like base install
#  if $install_type == 'Patch' {
#    require ::sqlserver::v2019::patch

#    sqlserver::common::patch_sqlserver_instance { $instance_name:
#      installer_path     => $::sqlserver::v2019::patch::installer,
#      applies_to_version => $::sqlserver::v2019::patch::applies_to_version,
#    }
#  }

  if $tcp_port > 0 {
    sqlserver::common::tcp_port { $instance_name:
      tcp_port => $tcp_port,
    }
  }

}
