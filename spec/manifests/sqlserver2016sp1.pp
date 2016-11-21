class { '::sqlserver::v2016':
  source             => $::sqlserver2016_iso_url,
  sa_password        => 'sdf347RT!',
  program_entry_name => 'Microsoft SQL Server 2016 (64-bit)',
  install_type       => 'SP1',
}
