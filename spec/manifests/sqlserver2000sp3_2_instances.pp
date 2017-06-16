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
