# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2005*') do
  it { should be_installed }
end

['SQL2005_1', 'SQL2005_2'].each do |instance_name|
  describe service("MSSQL$#{instance_name}") do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end
end

['1', '2'].each do |instance_number|
  describe windows_registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL.#{instance_number}\\Setup") do
    it { should exist }
    it { should have_property_value('PatchLevel', :type_string, '9.4.5000') }
  end
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.1\Setup') do
  it { should have_property_value('Collation', :type_string, 'Latin1_General_CI_AS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.1\Mssqlserver\Supersocketnetlib\tcp\ipall') do
  it { should have_property_value('tcpport', :type_string, '1433') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.2\Mssqlserver\Supersocketnetlib\tcp\ipall') do
  it { should have_property_value('tcpport', :type_string, '1434') }
end
