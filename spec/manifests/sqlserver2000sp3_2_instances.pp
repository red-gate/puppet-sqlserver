Reboot {
  timeout => 10,
}

package { 'procexp':
  ensure   => 'installed',
  provider => 'chocolatey',
}

class { 'sqlserver::v2000::iso':
  source => $facts['sqlserver2000_iso_url'],
}

class { 'sqlserver::v2000::sp3':
  source => $facts['sqlserver2000_sp3_url'],
}

sqlserver::v2000::instance { 'SQL2000_1':
  install_type          => 'Patch',
  sa_encrypted_password => '117f738fb1db5d4559d6f609',
  tcp_port              => 1433,
}
-> sqlserver::v2000::instance { 'SQL2000_2':
  install_type          => 'Patch',
  sa_encrypted_password => '117f738fb1db5d4559d6f609',
  sqlcollation          => 'Latin1_General_CS_AS_KS_WS',
  tcp_port              => 1434,
}

# Test setting options with the first instance

class { 'sqlserver::sqlcmd::install':
  version => '10', # v10 can connect to SQL Server 2000. v11 refuses to.
}

sqlserver::options::max_memory { 'SQL2000_1: Max Memory':
  server    => 'localhost\SQL2000_1',
  require   => Sqlserver::V2000::Instance['SQL2000_1'],
  value     => 512,
  issql2000 => true,
}

sqlserver::database::readonly { 'SQL2000_1: Set model readonly':
  server        => 'localhost\SQL2000_1',
  database_name => 'model',
  is_sql_2000   => true,
  require       => Sqlserver::V2000::Instance['SQL2000_1'],
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2000_1: BUILTIN\Users login':
  server      => 'localhost\SQL2000_1',
  login_name  => 'BUILTIN\Users',
  is_sql_2000 => true,
  require     => Sqlserver::V2000::Instance['SQL2000_1'],
}
-> sqlserver::users::login_role { 'SQL2000_1: BUILTIN\Users is sysadmin':
  server     => 'localhost\SQL2000_1',
  login_name => 'BUILTIN\Users',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2000_1: BUILTIN\Users default database is tempdb':
  server                => 'localhost\SQL2000_1',
  login_name            => 'BUILTIN\Users',
  default_database_name => 'tempdb',
  is_sql_2000           => true,
}
