# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server vNext CTP1.2 (64-bit)') do
  it { should be_installed }
end

['SQLBrowser', 'MSSQL$SQL2017', 'SQLAGENT$SQL2017'].each do |service_name|
  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end
end
