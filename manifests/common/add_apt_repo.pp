# @summary Adds SQL Server linux apt repo
#
# @param sql_version
#   Version of SQL Server to install
class sqlserver::common::add_apt_repo (
  Enum['2017','2019'] $sql_version
) {
  include apt

  apt::key { 'microsoft_apt_key':
    id     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
    server => 'keyserver.ubuntu.com',
  }

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

  apt::source { 'microsoft_sql_server_apt_repo':
    location => "https://packages.microsoft.com/ubuntu/${os_version_number}/mssql-server-${sql_version}",
    repos => 'main',
    release => $facts['os']['distro']['codename'],
    require => Apt::Key['microsoft_apt_key'],
  }

  apt::source { 'microsoft_prod_apt_repo':
    location => "https://packages.microsoft.com/ubuntu/${os_version_number}/prod",
    repos => 'main',
    release => $facts['os']['distro']['codename'],
    require => Apt::Key['microsoft_apt_key'],
  }
}
