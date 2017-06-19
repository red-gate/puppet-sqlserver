Reboot {
  timeout => 10,
}

package { 'procexp':
  ensure   => 'installed',
  provider => 'chocolatey',
}

class { '::sqlserver::v2000::iso':
  source => $::sqlserver2000_iso_url,
}

class { '::sqlserver::v2000::sp3':
  source => $::sqlserver2000_sp3_url,
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
  server  => 'localhost\SQL2000_1',
  require => Sqlserver::V2000::Instance['SQL2000_1'],
  value   => 512,
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2000_1: Everyone login':
  server     => 'localhost\SQL2000_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2000::Instance['SQL2000_1'],
}
->
sqlserver::users::login_role { 'SQL2000_1: Everyone is sysadmin':
  server     => 'localhost\SQL2000_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
  require    => Sqlserver::V2000::Instance['SQL2000_1'],
}