Reboot {
  timeout => 5,
}

class { '::sqlserver::v2016::resources':
  source       => $::sqlserver2016_iso_url,
  install_type => 'SP1',
}

sqlserver::v2016::instance { 'SQL2016_1':
  sa_password  => 'sdf347RT!',
  install_type => 'SP1',
  require      => Class['::sqlserver::v2016::resources'],
}

sqlserver::v2016::instance { 'SQL2016_2':
  sa_password  => 'sdf347RT!',
  install_type => 'SP1',
  require      => Class['::sqlserver::v2016::resources'],
}
