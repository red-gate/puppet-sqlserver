# Setup the 'max server memory (MB)' option
define sqlserver::options::max_memory($server, $value, $username = undef, $password = undef) {

  sqlserver::options::base { "${server} - Setting Max Memory to ${value}MB":
    server       => $server,
    username     => $username,
    password     => $password,
    option_name  => 'max server memory (MB)',
    option_value => $value,
  }
}
