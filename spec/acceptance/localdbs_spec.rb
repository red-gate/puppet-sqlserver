# Encoding: utf-8
require_relative 'spec_windowshelper'

[2012, 2014].each do |version|
  describe package("Microsoft SQL Server #{version} Express LocalDB ") do
    it { should be_installed }
  end
end

describe command("sqllocaldb info") do
  its(:stdout) { should match /MSSQLLocalDB/ }
  its(:stdout) { should match /v11.0/ }
end
