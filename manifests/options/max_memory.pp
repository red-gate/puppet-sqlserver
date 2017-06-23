# Setup the 'max server memory (MB)' option
#
# $issql2000: table/column/options names can be different if targeting SQL Server 2000. Set this to $true if targeting SQL Server 2000
define sqlserver::options::max_memory($server, $value, $username = undef, $password = undef, $issql2000 = false) {

  if $issql2000 {
    $option_name = 'Maximum size of server memory (MB)'
  } else {
    $option_name = 'max server memory (MB)'
  }

  sqlserver::options::base { "${server} - Setting Max Memory to ${value}MB":
    server          => $server,
    username        => $username,
    password        => $password,
    option_name     => $option_name,
    option_set_name => 'max server memory (MB)',
    option_value    => $value,
    issql2000       => $issql2000,
  }
}
