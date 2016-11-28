Reboot {
  timeout => 5,
}

class { '::sqlserver::v2016::iso':
  source => $::sqlserver2016_iso_url,
}

sqlserver::v2016::instance { 'SQL2016_1':
  sa_password  => 'sdf347RT!',
  install_type => 'Patch',
}

sqlserver::v2016::instance { 'SQL2016_2':
  sa_password   => 'sdf347RT!',
  install_type  => 'Patch',
  sql_collation => 'Latin1_General_CS_AS_KS_WS',
}
