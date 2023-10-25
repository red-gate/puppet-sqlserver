# @summary Installs linux SQL Server version
#
# @param sa_password
#     Required. Specify the password for the SA account
# @param mssql_product_id
#     Optional. Specify the product ID to install. Must be one of `evaluation`, `developer`, `express`, `web` or `enterprise`
#     Default: `evaluation`
# @param mssql_agent_enabled
#     Optional. Boolean. Specify if the SQL Agent should be enabled. 
#     Default: true
# @param install_sql_fulltext
#     Optional. Boolean. Specify if the SQL Full Text search should be enabled.
#     Default: false
# @param install_sql_tools
#     Optional. Boolean. Whether to install SQL tools or not.
#     Default: true
# @param ensure
#     Optinal. Specify the `ensure` value for the mssql-server and mssql-server-fts packages.
#     Default: latest
define sqlserver::common::install_sqlserver_linux (
  String $sa_password,
  Enum['evaluation','developer','express','web','enterprise'] $mssql_product_id,
  Boolean $mssql_agent_enabled = true,
  Boolean $install_sql_fulltext = false,
  Boolean $install_sql_tools = true,
  String $ensure = 'latest',
) {
  require  sqlserver::common::add_apt_repo

  package { 'mssql-server':
    ensure  => $ensure,
  }

  exec { 'Configure SQL Server':
    command     => '/opt/mssql/bin/mssql-conf -n setup accept-eula',
    environment => ["MSSQL_SA_PASSWORD=${sa_password}",
      "MSSQL_PID=${mssql_product_id}",
      "MSSQL_AGENT_ENABLED=${mssql_agent_enabled}",
    ],
    creates     => '/etc/systemd/system/multi-user.target.wants/mssql-server.service',
    require     => Package['mssql-server'],
  }

  service { 'mssql-server':
    ensure  => running,
    require => Exec['Configure SQL Server']
  }

  if($install_sql_fulltext) {
    package { 'mssql-server-fts':
      ensure  => $ensure,
      notify  => Service['mssql-service'],
    }
  }

  if($install_sql_tools) {
    include sqlserver::sqlcmd::install
  }
}
