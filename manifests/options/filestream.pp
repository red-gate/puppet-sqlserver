# Setup the 'filestream access level' option
define sqlserver::options::filestream($server, $value, $username = undef, $password = undef) {
  sqlserver::options::base { "${server} - Setting 'filestream access level' to ${value}":
    server       => $server,
    username     => $username,
    password     => $password,
    option_name  => 'filestream access level',
    option_value => $value,
  }
}
