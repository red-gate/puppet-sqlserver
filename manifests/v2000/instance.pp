# Install an configure a single SQL Server 2000 Instance.
#
# $install_type:
#   'RTM' (don't patch)
#   or
#   'Patch' (install the latest Service Pack/Patch/CU we are aware of.)
#
define sqlserver::v2000::instance(
  $sa_encrypted_password,
  $instance_name  = $title,
  $install_type   = 'Patch',
  $sqlcollation   = 'Latin1_General_CI_AS',
  $datadir        = 'D:\\',
  $tcp_port       = 0
  ) {

  if versioncmp($::kernelmajversion, '6.1') >= 0 {
    fail('Installing SQL Server 2000 is not supported on this OS.')
  }

  require ::sqlserver::v2000::iso

  $get_instancename_from_registry = "HKLM\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\${instance_name}\\MSSQLServer"

  $service_name = "MSSQL$${instance_name}"

  sqlserver::common::reboot_resources { $instance_name: }

  Exec {
    path    => 'C:/Windows/System32',
    timeout => 1800,
  }

  $template_file = "C:\\Windows\\Temp\\sql2000_${instance_name}.iss"
  $log_file = "C:\\Windows\\Temp\\sql2000_${instance_name}.rtm.log.txt"

  file { $template_file:
    ensure             => 'present',
    content            => template('sqlserver/2000dev.iss.erb'),
    source_permissions => ignore,
  }
  -> exec { "Install SQL Server instance: ${instance_name}":
    command => "\"${::sqlserver::v2000::iso::installer}\" -s -f1 ${template_file} -f2 ${log_file}",
    unless  => "reg.exe query \"${get_instancename_from_registry}\"",
    require => Reboot["reboot before installing ${instance_name} (if pending)"],
    returns => [0, 3010],
    notify  => Reboot["reboot before installing ${instance_name} Patch (if pending)"],
  }

  if $install_type == 'Patch' or $install_type == 'SP3' {
    $sp3_template_file = "C:\\Windows\\Temp\\sql2000_${instance_name}_sp3.iss"
    $sp3_log_file = "C:\\Windows\\Temp\\sql2000_${instance_name}.sp3.log.txt"

    require ::sqlserver::v2000::sp3

    file { $sp3_template_file:
      ensure             => 'present',
      content            => template('sqlserver/2000sp3a.iss.erb'),
      source_permissions => ignore,
    }
    -> exec { "${instance_name} SP3":
      command   => "\"${::sqlserver::v2000::sp3::installer}\" -s -f1 \"${sp3_template_file}\" -f2 \"${sp3_log_file}\"",
      logoutput => true,
      unless    => "cmd.exe /C reg query \"${get_instancename_from_registry}\\CurrentVersion\" /v CSDVersion | findstr ${::sqlserver::v2000::sp3::version}",
      require   => [
        Service[$service_name],
        Reboot["reboot before installing ${instance_name} Patch (if pending)"]
      ],
    }
    ~> exec { "Restart ${service_name} after SP3 upgrade":
      command     => "C:\\Windows\\System32\\sc.exe start ${service_name}",
      refreshonly => true,
    }
  }

  service { $service_name:
    ensure  => running,
    enable  => true,
    require => Exec["Install SQL Server instance: ${instance_name}"],
  }
}
