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

describe command("sqllocaldb info MSSQLLocalDB") do
  its(:stdout) { should match /Name:\s*MSSQLLocalDB/ }
end

describe command("sqllocaldb info v11.0") do
  its(:stdout) { should match /Name:\s*v11\.0/ }
end

describe package('Active Directory Authentication Library for SQL Server (x86)') do
  it { should be_installed }
end

describe package('Active Directory Authentication Library for SQL Server') do
  it { should be_installed }
end