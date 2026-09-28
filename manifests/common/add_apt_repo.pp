# @summary Adds SQL Server linux apt repo
#
# @param sql_version
#   Version of SQL Server to install
class sqlserver::common::add_apt_repo (
  Enum['2017','2019'] $sql_version
) {
  include apt

  $os_version_number = $facts['os']['release']['full']

  case $sql_version {
    '2017': {
      if(!($os_version_number in ['16.04', '18.04'])) {
        fail('SQL Server 2017 is only supported on Ubuntu 16.04 and 18.04')
      }
    }
    '2019': {
      if(!($os_version_number in ['16.04', '18.04', '20.04'])) {
        fail('SQL Server 2019 is only support on Ubuntu 16.04, 18.04 and 20.04')
      }
    }
    default: {
      fail('This version of SQL Server is not supported')
    }
  }

  apt::keyring { 'microsoft.asc':
    ensure => present,
    source => 'https://packages.microsoft.com/keys/microsoft.asc',
  }

  apt::source { 'microsoft_sql_server_apt_repo':
    location => "https://packages.microsoft.com/ubuntu/${os_version_number}/mssql-server-${sql_version}",
    repos => 'main',
    release => $facts['os']['distro']['codename'],
    keyring => '/etc/apt/keyrings/microsoft.asc',
    require => Apt::Keyring['microsoft.asc'],
  }

  apt::source { 'microsoft_prod_apt_repo':
    location => "https://packages.microsoft.com/ubuntu/${os_version_number}/prod",
    repos => 'main',
    release => $facts['os']['distro']['codename'],
    keyring => '/etc/apt/keyrings/microsoft.asc',
    require => Apt::Keyring['microsoft.asc'],
  }
}
