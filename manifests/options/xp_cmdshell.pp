# Setup the 'xp_cmdshell' option
#
# $issql2000: When set to true, this resource does nothing. xp_cmdshell is always enabled in SQL Server 2000.
define sqlserver::options::xp_cmdshell($server, $value, $username = undef, $password = undef, $issql2000 = false) {

  if !$issql2000 {
    sqlserver::options::base { "${server} - Setting xp_cmdshell to ${value}":
      server       => $server,
      username     => $username,
      password     => $password,
      option_name  => 'xp_cmdshell',
      option_value => $value,
    }
  }

}
