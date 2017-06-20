Reboot {
  timeout => 10,
}

class { '::sqlserver::v2008::iso':
  source => $::sqlserver2008_iso_url,
}

sqlserver::v2008::instance { 'SQL2008_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2008::instance { 'SQL2008_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}

# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2008_1: clr enabled':
  server  => 'localhost\SQL2008_1',
  require => Sqlserver::V2008::Instance['SQL2008_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2008_1: Max Memory':
  server  => 'localhost\SQL2008_1',
  require => Sqlserver::V2008::Instance['SQL2008_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2008_1: xp_cmdshell':
  server  => 'localhost\SQL2008_1',
  require => Sqlserver::V2008::Instance['SQL2008_1'],
  value   => 1,
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2008_1: Everyone login':
  server     => 'localhost\SQL2008_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2008::Instance['SQL2008_1'],
}
->
sqlserver::users::login_role { 'SQL2008_1: Everyone is sysadmin':
  server     => 'localhost\SQL2008_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2008_1: Everyone default database is tempdb':
  server                => 'localhost\SQL2008_1',
  login_name            => '\Everyone',
  default_database_name => 'tempdb',
}
