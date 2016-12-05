Reboot {
  timeout => 5,
}

class { '::sqlserver::v2014::iso':
  source => $::sqlserver2014_iso_url,
}

sqlserver::v2014::instance { 'SQL2014_1':
  sa_password  => 'sdf347RT!',
  install_type => 'Patch',
  tcp_port     => 1433,
}

sqlserver::v2014::instance { 'SQL2014_2':
  sa_password   => 'sdf347RT!',
  install_type  => 'Patch',
  sql_collation => 'Latin1_General_CS_AS_KS_WS',
  tcp_port      => 1434,
}
