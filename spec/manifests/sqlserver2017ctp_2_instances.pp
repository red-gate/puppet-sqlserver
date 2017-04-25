Reboot {
  timeout => 5,
}

class { '::sqlserver::v2017::iso':
  source => $::sqlserver2017_iso_url,
}

sqlserver::v2017::instance { 'SQL2017_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2017::instance { 'SQL2017_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}


# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2017_1: clr enabled':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2017_1: Max Memory':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2017_1: xp_cmdshell':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 1,
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2017_1: Everyone login':
  server     => 'localhost\SQL2017_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2017::Instance['SQL2017_1'],
}
->
sqlserver::users::login_role { 'SQL2017_1: Everyone is sysadmin':
  server     => 'localhost\SQL2017_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
  require    => Sqlserver::V2017::Instance['SQL2017_1'],
}
