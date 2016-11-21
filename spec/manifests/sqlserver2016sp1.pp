class { '::sqlserver::v2016':
  source       => $::sqlserver2016_iso_url,
  sa_password  => 'sdf347RT!',
  install_type => 'SP1',
}
