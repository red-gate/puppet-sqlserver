# Setup the 'clr enabled' option
define sqlserver::options::clr_enabled($server, $value, $username = undef, $password = undef) {
  sqlserver::options::base { "${server} - Setting 'CLR Enabled' to ${value}":
    server       => $server,
    username     => $username,
    password     => $password,
    option_name  => 'clr enabled',
    option_value => $value,
  }
}
