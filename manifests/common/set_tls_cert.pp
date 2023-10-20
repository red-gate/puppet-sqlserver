# @summary Set's the TLS certificate for an instance
#
# @param certificate_thumbprint
#     The thumbprint of the certificate in the LocalMachine\My certificate store.
#     It's CN MUST match the servers FQDN. It can optionally have additional SANs
#
# @param instance_name
#     The name of the SQL Instance to set the certificate on
#
define sqlserver::common::set_tls_cert (
  String $certificate_thumbprint,
  String $instance_name = $title,
) {
  exec { "Set TLS Cert on ${title}":
    provider  => 'powershell',
    command   => template('sqlserver/set_sql_tls_cert.ps1.erb'),
    onlyif    => template('sqlserver/should_set_sql_tls_cert.ps1.erb'),
    logoutput => true,
  }
}
