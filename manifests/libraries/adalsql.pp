# Install adalsql.dll as per
# https://docs.microsoft.com/en-us/sql/connect/jdbc/connecting-using-azure-active-directory-authentication#client-setup-requirements
class sqlserver::libraries::adalsql(
  $source_url_x64 = 'https://download.microsoft.com/download/6/4/6/64677D6E-06EA-4DBB-AF05-B92403BB6CB9/ENU/x64/adalsql.msi',
  $source_url_x86 = 'https://download.microsoft.com/download/6/4/6/64677D6E-06EA-4DBB-AF05-B92403BB6CB9/ENU/x86/adalsql.msi'
  ) {

  if $::architecture == 'x64' {
    archive { 'C:/Windows/Temp/adalsql_x64.msi':
      source => $source_url_x64,
    }
    -> package { 'Active Directory Authentication Library for SQL Server':
      source => 'C:/Windows/Temp/adalsql_x64.msi',
    }
  }

  archive { 'C:/Windows/Temp/adalsql_x86.msi':
    source => $source_url_x86,
  }
  -> package { 'Active Directory Authentication Library for SQL Server (x86)':
    source => 'C:/Windows/Temp/adalsql_x86.msi',
  }
}