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
          patch_level = ""
          
          Win32::Registry::HKEY_LOCAL_MACHINE.open("SOFTWARE\\Microsoft\\Microsoft SQL Server\\#{reg[name]}\\Setup") do |patch|
            patch_level = patch['PatchLevel']
          end
          
          result[name] = Hash[
            instance_name: reg[name],
            registry_path: "SOFTWARE\\Microsoft\\Microsoft SQL Server\\#{reg[name]}",
            patch_level: patch_level
          ]
        end
        result
      end
    rescue
      {} # return an empty hash
    end
  end
end
