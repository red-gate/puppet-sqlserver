# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2014 (64-bit)') do
  it { should be_installed }
end

# RTM version
describe package('SQL Server 2014 Database Engine Services') do
  it { should be_installed.with_version('13.0.1601.5') }
end

['SQLBrowser', 'MSSQL$SQL2014', 'SQLAGENT$SQL2014'].each do |service_name|
  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end
end
