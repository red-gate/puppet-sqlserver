# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2016 (64-bit)') do
  it { should be_installed }
end

# SP1 should be installed.
describe package('SQL Server 2016 Database Engine Services') do
  it { should be_installed.with_version('13.1.4001.0') }
end
