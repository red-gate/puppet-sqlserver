require_relative 'spec_windowshelper'

describe package('Microsoft SQL Server Management Studio - 19.*') do
  it { should be_installed}
end
