# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2014 (64-bit)') do
  it { should be_installed }
end

# RTM version
describe package('SQL Server 2014 Database Engine Services') do
  it { should be_installed.with_version('12.0.2000.8') }
end

['SQLBrowser', 'MSSQL$SQL2014', 'SQLAGENT$SQL2014'].each do |service_name|
  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQL2014\Setup') do
  it { should exist }
  it { should have_property_value('Version', :type_string, '12.0.2000.8') }
  it { should have_property_value('PatchLevel', :type_string, '12.0.2000.8') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQL2014\Setup') do
  it { should have_property_value('Collation', :type_string, 'Latin1_General_CI_AS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQL2014\Mssqlserver\Supersocketnetlib\tcp\ipall') do
  it { should have_property_value('tcpport', :type_string, '1433') }
end
