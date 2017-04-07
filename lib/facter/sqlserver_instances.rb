# Return a hash of installed SQL Server instances
Facter.add('sqlserver_instances') do
  confine kernel: 'windows'

  setcode do
    begin
      require 'win32/registry'

      hive = Win32::Registry::HKEY_LOCAL_MACHINE
      hive.open('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', Win32::Registry::KEY_READ | 0x100) do |reg|
        result = {}
        reg.each_value do |name|
          result[name] = Hash[
            instance_name: reg[name],
            registry_path: "SOFTWARE\\Microsoft\\Microsoft SQL Server\\#{reg[name]}"
          ]
        end
        result
      end
    rescue
      {} # return an empty hash
    end
  end
end
