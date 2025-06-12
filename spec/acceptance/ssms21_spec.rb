require_relative 'spec_windowshelper'

describe package('SQL Server Management Studio 21*') do
  it { should be_installed}
end
