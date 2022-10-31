# @summary Install an configure a single SQL Server 2019 Instance on Linux
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
# @param ensure
#     Optional. Specify the `ensure` value for the mssql-server and mssql-server-fts packages.
#     Default: latest
define sqlserver::v2017::linux(
  String $sa_password,
  Enum['evaluation','developer','express','web','enterprise'] $mssql_product_id,
  Boolean $mssql_agent_enabled = true,
  Boolean $install_sql_fulltext = false,
  $ensure = 'latest',
) {

  sqlserver::common::add_apt_repo {'sqlserver linux apt repo':
    sql_version  => '2017'
  } 


  sqlserver::common::install_sqlserver_linux {'install sqlserver linux 2017':
    sa_password          => $sa_password,
    mssql_product_id     => $mssql_product_id,
    mssql_agent_enabled  => $mssql_agent_enabled,
    install_sql_fulltext => $install_sql_fulltext,
    ensure               => $ensure,
  }

  
}
