Reboot {
  timeout => 5,
}

class { '::sqlserver::v2016':
  source       => $::sqlserver2016_iso_url,
  sa_password  => 'sdf347RT!',
  install_type => 'RTM',
}

# Test setting options

sqlserver::options::clr_enabled { 'SQL2016: clr enabled':
  server  => 'localhost\SQL2016',
  require => Class['::sqlserver::v2016'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2016: Max Memory':
  server  => 'localhost\SQL2016',
  require => Class['::sqlserver::v2016'],
  value   => 512,
}
