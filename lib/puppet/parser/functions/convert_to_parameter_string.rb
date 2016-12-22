module Puppet::Parser::Functions
  newfunction(
  :convert_to_parameter_string,
  :doc => "Serialize a hash to a string that can be passed to SQL Server setup.exe (/key1=\"value1\" /key2=\"value2\")",
  :type => :rvalue) do |args|
    hash = args[0]
    hash.map{|key, value| "/#{key.upcase}=\"#{value}\""}.join(' ')
  end
end
