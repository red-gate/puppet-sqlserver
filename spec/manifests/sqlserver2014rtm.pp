Reboot {
  timeout => 5,
}

class { '::sqlserver::v2014::iso':
  source => $::sqlserver2014_iso_url,
}

sqlserver::v2014::instance { 'SQL2014':
  sa_password  => 'sdf347RT!',
  install_type => 'RTM',
  tcp_port     => 1433,
}
