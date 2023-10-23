Reboot {
  timeout => 10,
}

package { 'procexp':
  ensure   => 'installed',
  provider => 'chocolatey',
}

class { 'sqlserver::v2005::iso':
  source => $facts['sqlserver2005_iso_url'],
}

sqlserver::v2005::instance { 'SQL2005_1':
  install_type   => 'SP4',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}
-> sqlserver::v2005::instance { 'SQL2005_2':
  install_type   => 'SP4',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}

# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2005_1: clr enabled':
  server  => 'localhost\SQL2005_1',
  require => Sqlserver::V2005::Instance['SQL2005_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2005_1: Max Memory':
  server  => 'localhost\SQL2005_1',
  require => Sqlserver::V2005::Instance['SQL2005_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2005_1: xp_cmdshell':
  server  => 'localhost\SQL2005_1',
  require => Sqlserver::V2005::Instance['SQL2005_1'],
  value   => 1,
}

sqlserver::database::readonly { 'SQL2005_1: Set model readonly':
  server        => 'localhost\SQL2005_1',
  database_name => 'model',
  require       => Sqlserver::V2005::Instance['SQL2005_1'],
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2005_1: BUILTIN\Users login':
  server     => 'localhost\SQL2005_1',
  login_name => 'BUILTIN\Users',
  require    => Sqlserver::V2005::Instance['SQL2005_1'],
}
-> sqlserver::users::login_role { 'SQL2005_1: BUILTIN\Users is sysadmin':
  server     => 'localhost\SQL2005_1',
  login_name => 'BUILTIN\Users',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2005_1: BUILTIN\Users default database is tempdb':
  server                => 'localhost\SQL2005_1',
  login_name            => 'BUILTIN\Users',
  default_database_name => 'tempdb',
}
