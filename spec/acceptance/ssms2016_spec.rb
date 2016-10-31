# Encoding: utf-8
require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server Management Studio - 16.*') do
  it { should be_installed}
end
