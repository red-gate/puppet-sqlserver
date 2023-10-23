# @summary Install sqlcmd.exe
#
# @param version
#   The version to install
# 
# @param temp_folder
#   Location of a temp folder
#
class sqlserver::sqlcmd::install (
  String $version = '11',
  String $temp_folder = 'C:/Windows/Temp'
) {
  if($facts['os']['family'] == 'windows') {
    case $version {
      '11': { include sqlserver::sqlcmd::install::v11 }
      '10': { include sqlserver::sqlcmd::install::v10 }
      default: { fail("version must be either 10 or 11. ${version} is not supported.") }
    }

    # The folders where to find sqlcmd.exe
    $paths = [
      'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/130/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/120/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/110/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/120/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/110/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/100/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/90/Tools/Binn',
      'C:/Program Files/Microsoft SQL Server/80/Tools/Binn',
    ]
  }
  else {
    exec { '/usr/bin/apt-get --force-yes --assume-yes install mssql-tools msodbcsql17':
      environment => 'ACCEPT_EULA=y',
      unless      => '/usr/bin/dpkg -l mssql-tools|tail -1|grep "^ii"',
      require     => Class['sqlserver::common::add_apt_repo'],
    }

    $paths = [
      '/opt/mssql-tools/bin',
    ]
  }
}
