Reboot {
  timeout => 5,
}

class { '::sqlserver::v2014::iso':
  source => $::sqlserver2014_iso_url,
}

sqlserver::v2014::instance { 'SQL2014_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2014::instance { 'SQL2014_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}

# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2014_1: clr enabled':
  server  => 'localhost\SQL2014_1',
  require => Sqlserver::V2014::Instance['localhost\SQL2014_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2014_1: Max Memory':
  server  => 'localhost\SQL2014_1',
  require => Sqlserver::V2014::Instance['localhost\SQL2014_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2014_1: xp_cmdshell':
  server  => 'localhost\SQL2014_1',
  require => Sqlserver::V2014::Instance['localhost\SQL2014_1'],
  value   => 1,
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2014_1: Everyone login':
  server     => 'localhost\SQL2014_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2014::Instance['localhost\SQL2014_1'],
}
->
sqlserver::users::login_role { 'SQL2014_1: Everyone is sysadmin':
  server     => 'localhost\SQL2014_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
  require    => Sqlserver::V2014::Instance['localhost\SQL2014_1'],
}
