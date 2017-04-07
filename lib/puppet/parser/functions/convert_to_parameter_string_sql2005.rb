module Puppet::Parser::Functions
  newfunction(
    :convert_to_parameter_string_sql2005,
    doc: 'Serialize a hash to a string that can be passed to SQL Server 2005 setup.exe (key1="value1" key2="value2")',
    type: :rvalue
  ) do |args|
    hash = args[0]
    hash.map { |key, value| "#{key.upcase}=\"#{value}\"" }.join(' ')
  end
end
