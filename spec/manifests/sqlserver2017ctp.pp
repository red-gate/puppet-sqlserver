Reboot {
  timeout => 5,
}

class { '::sqlserver::v2017':
  source       => $::sqlserver2017_iso_url,
  sa_password  => 'sdf347RT!',
  install_type => 'RTM',
}

# Test setting options

sqlserver::options::clr_enabled { 'SQL2017: clr enabled':
  server  => 'localhost\SQL2017',
  require => Class['::sqlserver::v2017'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2017: Max Memory':
  server  => 'localhost\SQL2017',
  require => Class['::sqlserver::v2017'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2017: xp_cmdshell':
  server  => 'localhost\SQL2017',
  require => Class['::sqlserver::v2017'],
  value   => 1,
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2017: Everyone login':
  server     => 'localhost\SQL2017',
  login_name => '\Everyone',
  require    => Class['::sqlserver::v2017'],
}
->
sqlserver::users::login_role { 'SQL2017: Everyone is sysadmin':
  server     => 'localhost\SQL2017',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
  require    => Class['::sqlserver::v2017'],
}
