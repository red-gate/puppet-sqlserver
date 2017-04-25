Reboot {
  timeout => 5,
}

class { '::sqlserver::v2016::iso':
  source => $::sqlserver2016_iso_url,
}

sqlserver::v2016::instance { 'SQL2016_1':
  install_type   => 'SP1',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2016::instance { 'SQL2016_2':
  install_type   => 'SP1',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}
