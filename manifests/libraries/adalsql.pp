# @summary Install adalsql.dll as per
#   https://docs.microsoft.com/en-us/sql/connect/jdbc/connecting-using-azure-active-directory-authentication#client-setup-requirements
#
# @param source_url_x64
#   URL to the x64 installer
#
# @param source_url_x86
#   URL to the x86 installer
#
class sqlserver::libraries::adalsql (
  String $source_url_x64 = 'https://download.microsoft.com/download/6/4/6/64677D6E-06EA-4DBB-AF05-B92403BB6CB9/ENU/x64/adalsql.msi',
  String $source_url_x86 = 'https://download.microsoft.com/download/6/4/6/64677D6E-06EA-4DBB-AF05-B92403BB6CB9/ENU/x86/adalsql.msi'
) {
  if $facts['os']['architecture'] == 'x64' {

    #archive { 'C:/Windows/Temp/adalsql_x64.msi':
    #  source => $source_url_x64,
    #}

    ::sqlserver::common::download_microsoft_file { 'adalsql_x64.msi':
      source => $source_url_x64,
      destination => 'C:/Windows/Temp/adalsql_x64.msi'
    }

    -> package { 'Active Directory Authentication Library for SQL Server':
      source => 'C:/Windows/Temp/adalsql_x64.msi',
    }
  }

  #archive { 'C:/Windows/Temp/adalsql_x86.msi':
  #  source => $source_url_x86,
  #}

  ::sqlserver::common::download_microsoft_file { 'adalsql_x86.msi':
    source => $source_url_x86,
    destination => 'C:/Windows/Temp/adalsql_x86.msi'
  }

  -> package { 'Active Directory Authentication Library for SQL Server (x86)':
    source => 'C:/Windows/Temp/adalsql_x86.msi',
  }
}
