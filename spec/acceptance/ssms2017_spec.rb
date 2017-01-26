# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server Management Studio - 17.*') do
  it { should be_installed}
end
