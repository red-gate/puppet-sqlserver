Vagrant.configure(2) do |config|
  config.vm.provision 'shell', inline: <<-SHELL
    "Disabling windows update service..."
    sc.exe config wuauserv start= disabled
    sc.exe stop wuauserv
  SHELL
end
