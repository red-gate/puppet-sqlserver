require_relative 'spec_windowshelper'

describe package('SQL Server Management Studio 22*') do
  it { should be_installed}
end
