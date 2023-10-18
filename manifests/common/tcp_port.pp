# Configure a SQL Server instance TCP ports.
# This will restart the SQL Server service if need be.
#
# $instance_name: The name of the SQL Server instance to configure
#
# $tcp_port: The TCP port number to use for this SQL Server instance.
define sqlserver::common::tcp_port(
  $tcp_port,
  $instance_name = $title
  ) {

  if $instance_name in $::sqlserver_instances {
    $registry_instance_path = $::sqlserver_instances[$instance_name]['registry_path']

    ensure_resource('service', "SQLAGENT$${instance_name}", { ensure => running, })

    exec { "Restart MSSQL$${instance_name} after changing TCP port":
      # Restart SQL Server ourselves so that we can pass /yes to net stop
      command     => "cmd.exe /c net stop \"MSSQL$${instance_name}\" /yes && net start \"MSSQL$${instance_name}\"",
      path        => 'C:/Windows/system32',
      refreshonly => true,
      # Make sure to refresh the SQL Agent service which is stopped when using net stop /yes
      notify      => Service["SQLAGENT$${instance_name}"],
    }

    registrykey { "${instance_name}: Disable dynamic ports":
      key     => "HKLM:\\${registry_instance_path}\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll",
      subName => 'TcpDynamicPorts',
      data    => '',
      require => Exec["Install SQL Server instance: ${instance_name}"],
    }
    ->
    registrykey { "${instance_name}: Set port to ${tcp_port}":
      key     => "HKLM:\\${registry_instance_path}\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll",
      subName => 'TcpPort',
      data    => $tcp_port,
      notify  => Exec["Restart MSSQL$${instance_name} after changing TCP port"],
    }

  } else {
    warning('Cannot retrieve SQL instance data from the $sqlserver_instances fact. Skip configuring TCP port in this run...')
  }

}
