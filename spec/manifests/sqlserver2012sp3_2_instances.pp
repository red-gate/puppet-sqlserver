Reboot {
  timeout => 5,
}

class { '::sqlserver::v2012::iso':
  source => $::sqlserver2012_iso_url,
}

sqlserver::v2012::instance { 'SQL2012_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2012::instance { 'SQL2012_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}
