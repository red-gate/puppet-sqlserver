# @summary Adds SQL Server linux apt repo
#
# @param sql_version
#   Version of SQL Server to install
define sqlserver::common::install_sqlserver_linux(
  String $sa_password,
  Enum['evaluation','developer','express','web','enterprise'] $mssql_product_id,
  Boolean $mssql_agent_enabled = true,
  Boolean $install_sql_fulltext = false,
  $ensure = 'latest',
) {

  package {'mssql-server':
    ensure  => $ensure,
    require => Sqlserver::Common::Add_apt_repo['sqlserver linux apt repo']
  }

  exec {'Configure SQL Server':
    command     => "/opt/mssql/bin/mssql-conf -n setup accept-eula",
    environment => ["MSSQL_SA_PASSWORD=${sa_password}",
                    "MSSQL_PID=${mssql_product_id}",
                    "MSSQL_AGENT_ENABLED=${mssql_agent_enabled}"
                  ],
    creates     => '/etc/systemd/system/multi-user.target.wants/mssql-server.service',
    require     => Package['mssql-server'],
  }

  service {'mssql-server':
    ensure  => running,
    require => Exec['Configure SQL Server']
  }

  if($install_sql_fulltext) {
    package {'mssql-server-fts':
      ensure  => $ensure,
      require => Sqlserver::Common::Add_apt_repo['sqlserver linux apt repo'],
      notify  => Service['mssql-service']
    }
  }


}
