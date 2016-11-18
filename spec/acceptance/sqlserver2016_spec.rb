# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server 2016 (64-bit)') do
  it { should be_installed }
end
