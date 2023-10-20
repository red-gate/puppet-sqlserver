Reboot {
  timeout => 10,
}

class { '::sqlserver::v2022::iso':
  source => $::sqlserver2022_iso_url,
}

sqlserver::v2022::instance { 'SQL2022_1':
  install_type   => 'Patch',
  install_params => {
    sapwd => 'sdf347RT!',
  },
  tcp_port       => 1433,
}

sqlserver::v2022::instance { 'SQL2022_2':
  install_type   => 'CTP',
  install_params => {
    sapwd        => 'sdf347RT!',
    sqlcollation => 'Latin1_General_CS_AS_KS_WS',
  },
  tcp_port       => 1434,
}


# Test setting options with the first instance

sqlserver::options::clr_enabled { 'SQL2022_1: clr enabled':
  server  => 'localhost\SQL2022_1',
  require => Sqlserver::V2022::Instance['SQL2022_1'],
  value   => 1,
}
sqlserver::options::max_memory { 'SQL2022_1: Max Memory':
  server  => 'localhost\SQL2022_1',
  require => Sqlserver::V2022::Instance['SQL2022_1'],
  value   => 512,
}
sqlserver::options::xp_cmdshell { 'SQL2022_1: xp_cmdshell':
  server  => 'localhost\SQL2022_1',
  require => Sqlserver::V2022::Instance['SQL2022_1'],
  value   => 1,
}

sqlserver::database::readonly { 'SQL2022_1: Set model readonly':
  server        => 'localhost\SQL2022_1',
  database_name => 'model',
  require       => Sqlserver::V2022::Instance['SQL2022_1'],
}

# Test logins/roles
sqlserver::users::login_windows { 'SQL2022_1: Everyone login':
  server     => 'localhost\SQL2022_1',
  login_name => '\Everyone',
  require    => Sqlserver::V2022::Instance['SQL2022_1'],
}
-> sqlserver::users::login_role { 'SQL2022_1: Everyone is sysadmin':
  server     => 'localhost\SQL2022_1',
  login_name => '\Everyone',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2022_1: Everyone default database is tempdb':
  server                => 'localhost\SQL2022_1',
  login_name            => '\Everyone',
  default_database_name => 'tempdb',
}

# SQL Server login
sqlserver::users::login_sql { 'SQL2022_1: sql_user login':
  server     => 'localhost\SQL2022_1',
  login_name => 'sql_user',
  password   => 'SomePassw0rdForT3stPurposes!',
  require    => Sqlserver::V2022::Instance['SQL2022_1'],
}
-> sqlserver::users::login_role { 'SQL2022_1: sql_user is sysadmin':
  server     => 'localhost\SQL2022_1',
  login_name => 'sql_user',
  role_name  => 'sysadmin',
}
-> sqlserver::users::default_database { 'SQL2022_1: sql_user default database is tempdb':
  server                => 'localhost\SQL2022_1',
  login_name            => 'sql_user',
  default_database_name => 'tempdb',
}


$keycontent = "-----BEGIN PRIVATE KEY-----
MIIJQwIBADANBgkqhkiG9w0BAQEFAASCCS0wggkpAgEAAoICAQDvSW8WpVH/LOLe
ozrhNrbo7Z2XUNuFaxT9VtMinHzixka5z/+vVkIyNCC0+HwT3gyC/oIXbUf1WJkK
zJIbtnA9WqmY+Dhzu08lHNES06nmZFs2ZX9fnn0+XeUjeG9mT+7ANUsaUUkHOtCW
z0wM9nxISPudmkve8BS3lgOHL7kEJTM8UJxZmt5SeqKcD5ZudE6bCIA+s8Ugunfb
4Z6rcNdDLhGbAbZpCw9QSHZaU1O+bcRO1aJDapncBNz4USuA3yfg1AR6AdoP+gYJ
2fEzC8l1FbfE0oWZQBUx66CmImiPJw4/5BgeGrFSzTu7JllJrD6YB98DaBuXI6Th
Skj5zuou8JYsWTyGXINmq2aLep0kbuodpbUx6Zb+UvcHTEhpO501i5bTksPQXH6T
i03vZrt18iygSCAy5F+cukJbVaayUlZ6U7pGg0FnbY7lFiibMrkG2nNWkV59vac0
1nYgWbVqxBSG7JfdWSIoYzojwuhjO6PS9+EWl1C/RJcj2OdljutzJTFxOq7msbF5
4gRHccQOCQ/ypHWdbWBYNXTSUs6ElaFpFBvgI9BlU0+SYkDW/kG2UYE7LyBD4GhZ
R/3x5OJK/J4uNTL1gRuTl5c7xj3G7BJv79HUeM+tFtB07lZl3bqam7v7cGXJqUYu
TcsyyiCUS3EyHS21kCfyBgKCIYgoBwIDAQABAoICAQDP+IMUq5sYrWqBFl2WYHeY
+ux9F0m0K92SUmQvMNNaRfoyhRU0z0O5XpUOtOkiW1uEfq+SrOhd1SMuv549d9MV
gDbnPNXTwHiJSQJt2olQNOkR3iVWdelkyzbcHVC1G8PmSmt79CoEnpmseX8fxRs/
uC74S6KloQRgi4GFfXTQpYRiZ618M54HEY9DFEkqtuua00ijNpueVnLWKMI/P1PY
j7G9hz+DDJnCrTgwSTv/xmdYHVVqQrx2/cMQD3xABbQjNCKv5+we9q9I4KNCOnxd
xwJxjoePKqNBQAngWweFY+x+m0Ba6dg0nyvK/Qmdfpboi+7IhzNzqQckx+ulMrFV
bIfORZ9aOUugGkuFCSOVqAVjX9Vfz/rLOQQrCyQFUYgCFkaX1jvX9OTri7hw9C06
Yu2ywdpKdpw8e3Yw3obReX6JuzH8hrl5isKYpyrO1ttSGZtQUmDVXx1iWamJjhxv
Cyfd4KLLFyKHc3DlgM7xC2qR44KHmqjjnckkTaDAzQ7EimVqNNCdmNilCazn/FcT
zx3Cmm+65eUZTqkrK0kdjCYXYb0h7XAYbor1mVHh71tjTVf5gYF+NYMaEPaaIQi3
Az8kmSTRy5L5SkAXJT2xubCykRxVceb6d0xnZkxcLn3QpZSyLqI2n5U9KRrzw4ci
9rSaykSrjUFkGC3mX664AQKCAQEA+UAakWJ4DVfxoZr2AMDhIqkH212z4JSD1G9g
EEL/HDkrQt93L2D9aSDHG0RwKS4AZMHdR0Z5PD5S+547UPIYTcBwNrUCF8Ab8sDa
ICU5xvEfitBQeqWb5dAMjY7CpgelFAR7zmTdFjZ4E13kIRMS3sUXaPFyKxy/hU9a
iMDxdw1KF0MLjXBAfsaEVu0I3qzEU4yT5U3CDw0qxuXkD/Ep5cT5QQA7zH7XmKxu
ICc76vhirBr9NdQlIZb+2hUikI65oTi45y63YzzWK3kNBD/ihniEMJsoSipkr4OU
+YF66Czfsm/583UkhGboEKcm0gv4Vq2CKriNswUHztYnngqxqQKCAQEA9cRCVODQ
7lo6ehENVEjaQccTCMrWdefksDj3ITPwNcRPwcYcZwlyqOGuBEw+m8NTickCpVJ6
lmj38sOQ98yMNbNdRQWXlK69p2gPFoBC7HRNwsbKV4INRu3f1vHZtmJsV13PQCNF
nCv7kzPd5g5UjxVArC8EXQcihY0ZLL9p0ea14pi7RpSSKlUbpS94fhjw8bHjYk8q
8pqEERBlikCM7a/7AeazG2iJ2h5gf+i6bC3qwwwuCgDCdAZ/KDm7Fp1iIVZSZB9g
IN5uMJsn+WmndLEFVrutRM9d1ylbafTVsmqkUPeez/n4Q5isW89ZyFroemlKIKBY
+EKfBsTPPA96LwKCAQBtp2YIz+lA9Y+4KRRRAIoLVZG/UFnyU2Qr8VOx08eoAv6l
TOqCTYku1tzBgjpV44cIzMEsujRb7I9VYyd1VQycKC015CwnhrzE71MHEVl5zFq0
FzFQw8ryL7VWEZhQssxNIivVgUpCm3P4ETZr1phWqR7DbHVtwhf/7glGYJvaZF5U
HYrXjqrRG0TdeSqNzDQTDaWDG9JkDMbk+f57hP2JuD5v+kpUjPkMkc9hFeGmXeAL
F1SOeeZcALHd/65VKnVAGFRAYK0NW5ZdScQQOorN3fdJ6viuqDfjf1/q5KvNuPAw
8FJmaQLHvP4bVW4eumVmvK6nXMn6GBx3Qn/rZ4kBAoIBAAZELcjKPqmFJW6NVsCq
Zt48fDDCMzuoYP1ZRnvTPjGwwrPXIExEQmcp8ezsIMCJ92xQ8r9SXgvNu1y2PdED
pyOLYjprTRUea3mEPrY9KPesc3se5HPcvgfr8sQhQILU+Zw0qR8ihxjXSj/Tl7nQ
7bkEOrTpMfxJPUkYcubgLouKjWKssEG5cgygROcuUa0tZ59SANE14Yt0AyAIQf6H
bNB2pzjCMBjnznQASEeaoH43oX+9pMLeiBa7P6y/5BRMiP7+m3UwE5xi735PxnIm
jn18Mf2nJWDWxLbCuDD4bCZzb6Mc3TDCV+EpWGOy4sAoCTttydURIZOa50Ed7YbD
gkMCggEBAMAyBYwYAPC/EFTTfK1nRJgX6/KVkL+9hrA2Xl2ykT7AsUcEMCrsjf5g
Yk+jVQh+sg42KPnodQ+Dg44T0mSXqAwlrLp4x/el2R6KCrPvN3xr5skqCN4O0KYV
avwluAM0sry5Mqp/R+eEtQZ2TRCht8dyDT6n7c6KwZUZS0S0EwNTtNWBps0Vpmo9
JI1yJ7H8G44swoZDbInMrWLuAgjLjtODygHh/cLHX+pKOS+mAItGjjcd774m/iIt
1fi+ux00mBPmjBax7rdqbOUI1uudyZ7DpMUPpwurfYeyz1Ab79QA7CTsuO8JXMP3
cTKL2C551TgjFT4PGsmDrS2CzZnnvrA=
-----END PRIVATE KEY-----"

$certcontent = "-----BEGIN CERTIFICATE-----
MIIFYzCCA0ugAwIBAgIUNtJlBS69yBF/0sNYM7TF3jx8DS0wDQYJKoZIhvcNAQEL
BQAwTDELMAkGA1UEBhMCR0IxHjAcBgNVBAoTFVJlZCBHYXRlIFNvZnR3YXJlIEx0
ZDEdMBsGA1UEAxMUY2VydHRlc3QuZXhhbXBsZS5jb20wHhcNMjMxMDEzMTg1OTE0
WhcNMjMxMDIwMTg1OTE0WjBMMQswCQYDVQQGEwJHQjEeMBwGA1UEChMVUmVkIEdh
dGUgU29mdHdhcmUgTHRkMR0wGwYDVQQDExRjZXJ0dGVzdC5leGFtcGxlLmNvbTCC
AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAO9JbxalUf8s4t6jOuE2tujt
nZdQ24VrFP1W0yKcfOLGRrnP/69WQjI0ILT4fBPeDIL+ghdtR/VYmQrMkhu2cD1a
qZj4OHO7TyUc0RLTqeZkWzZlf1+efT5d5SN4b2ZP7sA1SxpRSQc60JbPTAz2fEhI
+52aS97wFLeWA4cvuQQlMzxQnFma3lJ6opwPlm50TpsIgD6zxSC6d9vhnqtw10Mu
EZsBtmkLD1BIdlpTU75txE7VokNqmdwE3PhRK4DfJ+DUBHoB2g/6BgnZ8TMLyXUV
t8TShZlAFTHroKYiaI8nDj/kGB4asVLNO7smWUmsPpgH3wNoG5cjpOFKSPnO6i7w
lixZPIZcg2arZot6nSRu6h2ltTHplv5S9wdMSGk7nTWLltOSw9BcfpOLTe9mu3Xy
LKBIIDLkX5y6QltVprJSVnpTukaDQWdtjuUWKJsyuQbac1aRXn29pzTWdiBZtWrE
FIbsl91ZIihjOiPC6GM7o9L34RaXUL9ElyPY52WO63MlMXE6ruaxsXniBEdxxA4J
D/KkdZ1tYFg1dNJSzoSVoWkUG+Aj0GVTT5JiQNb+QbZRgTsvIEPgaFlH/fHk4kr8
ni41MvWBG5OXlzvGPcbsEm/v0dR4z60W0HTuVmXdupqbu/twZcmpRi5NyzLKIJRL
cTIdLbWQJ/IGAoIhiCgHAgMBAAGjPTA7MDkGA1UdEQQyMDCCFGNlcnR0ZXN0LmV4
YW1wbGUuY29tghh3d3cuY2VydHRlc3QuZXhhbXBsZS5jb20wDQYJKoZIhvcNAQEL
BQADggIBABZRY2eKbyBtTo5jhRdXYJq0p0NUsmrrCf1/IG++Is7BR+a6T7tr3Mag
XJTN1rkT3tqXwW6WZRhc5+sgspmcqSanrFP8PVs0hhC7Xb0mK3Sz5hRTk3tcW4tc
B5ip7nsvIWepCzQMz/2DZ4yEpmfuMYKH0v3PsxDbZaHLrE1VJpgkXDyzEqgUc0Rc
b+hjLxR/864AyddB5nxIOLQSahRjBPHEZbnhk5rfvcFl4PhuHiL38tDuSGmoSfOE
usqgoX129ZywmJyorF18wRBobOdk5xPbgrMedGH/wte19GYiXJaKPk5lHzqY4TzB
YtXzgu9XLcdETxTOXnAJtAMUSkMCecRk5bkDVJ6FY8j+1U0a/DBjofzsqK9MStfl
Odaal1DMKLA9dw7pBHHDrd5WWYRoHY8dmCFdbBa/akLg5JIvW+W72tA1+KAwdK5D
BSlPG1/qQNmMGjEAF+LgDL+ZFTMpali0Bgyn1gu6THnKD73qKB4KbCaIJ3wSEf5B
jvCKhFNyFa+zeQtKya66kLcoOaixaAgPPj0x24HHConLzzyjXV/jPvz+899Htg5J
4rCUXqL3pVUx8qBoxmQMX+XiMDGLecBNRaUvBHAtTr9bxB9pAG/QNfiickD+K+VE
tq3sht7GsUOUvLy012ugzOc/sjQfBVPl4jMNfT4SvudbqRx15IRa
-----END CERTIFICATE-----"

sslcertificate::from_pem { 'test-cert':
  cert_content => $certcontent,
  key_content  => $keycontent,
}

sslcertificate::key_acl { 'sql_service_1_cert_read':
  identity        => 'NT Service\\MSSQL`$SQL2022_1',
  cert_thumbprint => '1822371B4C27B4683BADBADC91AFFE33732CFC55',
  require         => [Sslcertificate::From_Pem['test-cert'], Sqlserver::V2022::Instance['SQL2022_1']],
}

sslcertificate::key_acl { 'sql_service_2_cert_read':
  identity        => 'NT Service\\MSSQL`$SQL2022_2',
  cert_thumbprint => '1822371B4C27B4683BADBADC91AFFE33732CFC55',
  require         => [Sslcertificate::From_Pem['test-cert'], Sqlserver::V2022::Instance['SQL2022_2']],
}

sqlserver::common::set_tls_cert { 'Set_SQL2022_1_TLS_Cert':
  certificate_thumbprint => '1822371B4C27B4683BADBADC91AFFE33732CFC55',
  instance_name => 'SQL2022_1',
  require => [Sqlserver::V2022::Instance['SQL2022_1'], Sslcertificate::Key_acl['sql_service_1_cert_read']],
}

sqlserver::common::set_tls_cert { 'Set_SQL2022_2_TLS_Cert':
  certificate_thumbprint => '1822371B4C27B4683BADBADC91AFFE33732CFC55',
  instance_name => 'SQL2022_2',
  require => [Sqlserver::V2022::Instance['SQL2022_2'], Sslcertificate::Key_acl['sql_service_2_cert_read']],
}
