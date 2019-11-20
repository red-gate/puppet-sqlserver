Reboot {
  timeout => 10,
}

class { '::sqlserver::v2019::iso':
  source => $::sqlserver2019_iso_url,
}

sqlserver::v2019::instance { 'SQL2019_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2019::instance { 'SQL2019_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}


# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2019_1: clr enabled':
  server  => 'localhost\SQL2019_1',
  require => Sqlserver::V2019::Instance['SQL2019_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2019_1: Max Memory':
  server  => 'localhost\SQL2019_1',
  require => Sqlserver::V2019::Instance['SQL2019_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2019_1: xp_cmdshell':
  server  => 'localhost\SQL2019_1',
  require => Sqlserver::V2019::Instance['SQL2019_1'],
  value   => 1,
}

sqlserver::database::readonly { 'SQL2019_1: Set model readonly':
  server        => 'localhost\SQL2019_1',
  database_name => 'model',
  require       => Sqlserver::V2019::Instance['SQL2019_1'],
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2019_1: Everyone login':
  server     => 'localhost\SQL2019_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2019::Instance['SQL2019_1'],
}
->
sqlserver::users::login_role { 'SQL2019_1: Everyone is sysadmin':
  server     => 'localhost\SQL2019_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2019_1: Everyone default database is tempdb':
  server                => 'localhost\SQL2019_1',
  login_name            => '\Everyone',
  default_database_name => 'tempdb',
}

# SQL Server login
sqlserver::users::login_sql { 'SQL2019_1: sql_user login':
  server     => 'localhost\SQL2019_1',
  login_name => 'sql_user',
  password   => 'SomePassw0rdForT3stPurposes!',
  require    => Sqlserver::V2019::Instance['SQL2019_1'],
}
-> sqlserver::users::login_role { 'SQL2019_1: sql_user is sysadmin':
  server     => 'localhost\SQL2019_1',
  login_name => 'sql_user',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2019_1: sql_user default database is tempdb':
  server                => 'localhost\SQL2019_1',
  login_name            => 'sql_user',
  default_database_name => 'tempdb',
}
