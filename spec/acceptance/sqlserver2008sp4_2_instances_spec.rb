# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2008 (64-bit)') do
  it { should be_installed }
end

['SQL2008_1', 'SQL2008_2'].each do |instance_name|
  describe service("MSSQL$#{instance_name}") do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end

  describe windows_registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL10.#{instance_name}\\Setup") do
    it { should exist }
    it { should have_property_value('PatchLevel', :type_string, '10.4.6556.0') }
  end
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.SQL2008_1\Setup') do
  it { should have_property_value('Collation', :type_string, 'Latin1_General_CI_AS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.SQL2008_1\Mssqlserver\Supersocketnetlib\tcp\ipall') do
  it { should have_property_value('tcpport', :type_string, '1433') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.SQL2008_2\Setup') do
  it { should have_property_value('Collation', :type_string, 'Latin1_General_CS_AS_KS_WS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.SQL2008_2\Mssqlserver\Supersocketnetlib\tcp\ipall') do
  it { should have_property_value('tcpport', :type_string, '1434') }
end
