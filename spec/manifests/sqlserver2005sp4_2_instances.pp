Reboot {
  timeout => 10,
}

package { 'procexp':
  ensure   => 'installed',
  provider => 'chocolatey',
}

class { '::sqlserver::v2005::iso':
  source => $::sqlserver2005_iso_url,
}

sqlserver::v2005::instance { 'SQL2005_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}
->
sqlserver::v2005::instance { 'SQL2005_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}
