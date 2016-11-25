# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2016 (64-bit)') do
  it { should be_installed }
end

# RTM version
describe package('SQL Server 2016 Database Engine Services') do
  it { should be_installed.with_version('13.0.1601.5') }
end
