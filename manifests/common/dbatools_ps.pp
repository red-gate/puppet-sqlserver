# @summary Installs the DBA Tools powershell module
#
class sqlserver::common::dbatools_ps () {
  require chocolatey
  package { 'dbatools':
    ensure => latest,
    provider => chocolatey,
  }
}
