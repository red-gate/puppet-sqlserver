Reboot {
  timeout => 10,
}

$keycontent = "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtcxQDHDD3Iq+Ab/JqUZGHVqsd7D8PgotcrU62gczEUApFkpI
FrWKDGIUxnWRPDKaY+HZC2IGSXYEl/Hz+GCko8kVc1q3OPq2ATu24w++KQWD4K4y
I1c3b0nWnFLHcKAUmnrupKeBfGN2WR3fzCofZEodJ5cFSi6vye2hY2QRhVF+rpNA
LllE1B74USZ4vMt9jsr/I39XnOB9m72xW767llBJRcf/bl/KyC56g8opvSxhZjeB
3M5h488NjSzoU+U+t5cSXtZKVOMWAmPb+nlTEulcOubtGlYFnFrVh6jvONacylLv
TONzd4lL96DDd16PcBOqHM3++5VEwWEanHMRyQIDAQABAoIBAQCJAEti1KgFT1kZ
IFrsgdTc0jQejvXIGwtc4k5TeBF38o4ECj6BPpWl91QIqxij8M6AbvaNqXVrbtDP
YLqmds4bz7GmmLpy6hy2mTWdr4NyjoFvlFacY2GXMGHWtFsv+LMOJ44n70OZZasO
RYEd7rBxd5i4+Qo3eS9oUPfKWuMJP7duvErEKL2BDFLPwbWlUM+Cbz9Kddh2kUy+
cALtqI9JoyXxOPNXLQLEsS4HEXc3ZoKBsDjsNn6ng2kyzVRNNcIII3I2g1bFr2/d
+o7PNBsswwAJ/58rwRZc7NH3kwUYu52Boonmb8EaQtz6PxmkVAdwKCdNd5f0byue
d4bjtDRxAoGBAM6Ry8p0z6FwHFUon/ponOjD9k7qDXyOmGALPaWRAfaVzaVioZ5E
6Ne9qbRzpT+I8xrW41re2OOUvH26K1ApjXEld/CI6KdfWHH4tzgu4RTXxdHbh3ev
p0u59nuZdv/+gJ1xRO6YKXrxwEq/1Ij9kAJ3AZcXqADHujMR4nYNj8Z3AoGBAOFN
DH7dsy4cctQcP45R04jvvk7ESwGTtxYUtzDa9C+f24cwmKlF/hUD0mhYV4OhJmsy
CIXOK604EWrytz9pYjxsqzKJdDvNo2jbMojVDg+TVD1x7m7I/8jCwai3foWHQStM
CJ1ITQmzURWijjwogELZRGCTqEwkBQizBhw8zrm/AoGBALAeViYzGaOGtmFU1bDl
6IH8MdBudTkxSnD4pIK483eNmVvcj/ckwXDPYBVeVBGrbboAZK9hOIIwmdSIGc2q
39EMJQqLb/DjtcDWUUAxl+3xWdPm28ULmhNSZfhTi8YO8xFJNYBHc3ZDD7OrgkWa
CmJPnKd5n9+qafKI2Q/V2DNZAoGABiyaXw+sTWMyMmXjx/6uEV6glIAEnjJyHgTL
UGdvsa5r0bSfOmRUpjbImVtyaoUMDHv+h8wynjifIZMtOmuk6YsA1g22Rb1I8SKw
q9dK31pmQJjSs+6GM/ZCYGFG8lnWi102DzlgAxgK7NDbnQJvIWXa3dquDggeqzJc
xIFWGPkCgYAaLQcxh9LyLDjYoYwflSD/pGTvwcGzVi0w7XW6Xpq1wv7zAtXCrsqx
GWCNgqbVMeBtNBpxpOqzDO67mDF/CJ8dp+idD3UFtXQLZXaUsQdWAQ+ctPNMWI7j
oia49VlwcneVgeZGSdBv6TEnurraH7ViCSCAixKgigIv2gzi3WzoBw==
-----END RSA PRIVATE KEY-----"

$certcontent = "-----BEGIN CERTIFICATE-----
MIIDGDCCAgCgAwIBAgIQT4NQxTtJy41KQFVxeEGG4DANBgkqhkiG9w0BAQsFADAU
MRIwEAYDVQQDDAlzcWxzZXJ2ZXIwHhcNMjMxMDIwMTUzMjE3WhcNMjYxMDIwMTU0
MjE3WjAUMRIwEAYDVQQDDAlzcWxzZXJ2ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQC1zFAMcMPcir4Bv8mpRkYdWqx3sPw+Ci1ytTraBzMRQCkWSkgW
tYoMYhTGdZE8Mppj4dkLYgZJdgSX8fP4YKSjyRVzWrc4+rYBO7bjD74pBYPgrjIj
VzdvSdacUsdwoBSaeu6kp4F8Y3ZZHd/MKh9kSh0nlwVKLq/J7aFjZBGFUX6uk0Au
WUTUHvhRJni8y32Oyv8jf1ec4H2bvbFbvruWUElFx/9uX8rILnqDyim9LGFmN4Hc
zmHjzw2NLOhT5T63lxJe1kpU4xYCY9v6eVMS6Vw65u0aVgWcWtWHqO841pzKUu9M
43N3iUv3oMN3Xo9wE6oczf77lUTBYRqccxHJAgMBAAGjZjBkMA4GA1UdDwEB/wQE
AwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwEwFAYDVR0RBA0wC4IJ
c3Fsc2VydmVyMB0GA1UdDgQWBBQokf5wTOV166C+3t+JS7ERze51ZjANBgkqhkiG
9w0BAQsFAAOCAQEATrnH2d0+uPSuh/5zDL9WY1gC7ij/qChYZZ13kGW55GFK+bZH
CIdX2jjXKh8p8B9XI+eLXBddwGwxYwKNWVbfXUrtEHk3s216mW/qp1JAH7vnOFkt
yNkMPGBrpdPGX6dgDKsVuRA00BC8erj41g/+3gMjSJW5kJkju2pP2Eq6v0I3kPwB
EqO7EltDqbC2HqNrxYCzsyjusPfIzdAVHxl61YGvFtIJWfQr2/CCCuOHfgItx7Qf
/hKifAq7zLyhBjJyam6F0OvQ7a+cOPcPRZXlsFFqknQxYuBWS4GGbeuO+eWfX08h
ECLteEa3tTLfpuwy2F6a3IZdxPuo00N40Nrtkg==
-----END CERTIFICATE-----"

sslcertificate::from_pem { 'test-cert':
  cert_content => $certcontent,
  key_content  => $keycontent,
}

class { 'sqlserver::v2017::iso':
  source => $::sqlserver2017_iso_url,
}

sqlserver::v2017::instance { 'SQL2017_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
  certificate_thumbprint => '3401AEE89B13985BFE3BEFFDE853D574E0243E09',
  require => Sslcertificate::From_pem['test-cert'],
}

sqlserver::v2017::instance { 'SQL2017_2':
  install_type   => 'Patch',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}

# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2017_1: clr enabled':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2017_1: Max Memory':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2017_1: xp_cmdshell':
  server  => 'localhost\SQL2017_1',
  require => Sqlserver::V2017::Instance['SQL2017_1'],
  value   => 1,
}

sqlserver::database::readonly { 'SQL2017_1: Set model readonly':
  server        => 'localhost\SQL2017_1',
  database_name => 'model',
  require       => Sqlserver::V2017::Instance['SQL2017_1'],
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2017_1: Everyone login':
  server     => 'localhost\SQL2017_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2017::Instance['SQL2017_1'],
}
-> sqlserver::users::login_role { 'SQL2017_1: Everyone is sysadmin':
  server     => 'localhost\SQL2017_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2017_1: Everyone default database is tempdb':
  server                => 'localhost\SQL2017_1',
  login_name            => '\Everyone',
  default_database_name => 'tempdb',
}

# SQL Server login
sqlserver::users::login_sql { 'SQL2017_1: sql_user login':
  server     => 'localhost\SQL2017_1',
  login_name => 'sql_user',
  password   => 'SomePassw0rdForT3stPurposes!',
  require    => Sqlserver::V2017::Instance['SQL2017_1'],
}
-> sqlserver::users::login_role { 'SQL2017_1: sql_user is sysadmin':
  server     => 'localhost\SQL2017_1',
  login_name => 'sql_user',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2017_1: sql_user default database is tempdb':
  server                => 'localhost\SQL2017_1',
  login_name            => 'sql_user',
  default_database_name => 'tempdb',
}
