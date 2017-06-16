# Encoding: utf-8
require_relative 'spec_windowshelper'

['SQL2000_1', 'SQL2000_2'].each do |instance_name|
  describe service("MSSQL$#{instance_name}") do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end

  describe package("Microsoft SQL Server 2000 (#{instance_name})") do
    it { should be_installed }
  end

  describe windows_registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\#{instance_name}\\MSSQLServer\\CurrentVersion") do
    it { should exist }
    it { should have_property_value('CSDVersion', :type_string, '8.00.761') }
  end
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\SQL2000_1\\MSSQLServer') do
  it { should have_property_value('DefaultCollationName', :type_string, 'Latin1_General_CP1_CI_AS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\SQL2000_1\\MSSQLServer\Supersocketnetlib\tcp') do
  it { should have_property_value('tcpport', :type_string, '1433') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\SQL2000_2\\MSSQLServer') do
  it { should have_property_value('DefaultCollationName', :type_string, 'Latin1_General_CS_AS_KS_WS') }
end

describe windows_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\SQL2000_2\\MSSQLServer\Supersocketnetlib\tcp') do
  it { should have_property_value('tcpport', :type_string, '1434') }
end