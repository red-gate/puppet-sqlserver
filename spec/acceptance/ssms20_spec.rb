require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server Management Studio - 20.*') do
  it { should be_installed}
end
