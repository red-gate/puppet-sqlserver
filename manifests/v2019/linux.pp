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
# @param install_sql_tools
#     Optional. Boolean. Whether to install SQL tools or not.
#     Default: true
# @param ensure
#     Optional. Specify the `ensure` value for the mssql-server and mssql-server-fts packages.
#     Default: latest
define sqlserver::v2019::linux(
  String $sa_password,
  Enum['evaluation','developer','express','web','enterprise'] $mssql_product_id,
  Boolean $mssql_agent_enabled = true,
  Boolean $install_sql_fulltext = false,
  Boolean $install_sql_tools = true,
  $ensure = 'latest',
) {

  class {'sqlserver::common::add_apt_repo':
    sql_version  => '2019'
  } 


  sqlserver::common::install_sqlserver_linux {'install sqlserver linux 2019':
    sa_password          => $sa_password,
    mssql_product_id     => $mssql_product_id,
    mssql_agent_enabled  => $mssql_agent_enabled,
    install_sql_fulltext => $install_sql_fulltext,
    install_sql_tools    => $install_sql_tools,
    ensure               => $ensure,
  }

  
}
