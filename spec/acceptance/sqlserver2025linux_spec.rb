# Encoding: utf-8
require_relative 'spec_linuxhelper'

describe service('mssql-server') do
  it { should be_running }
  it { should be_enabled }
end