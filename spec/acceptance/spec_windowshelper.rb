require 'serverspec'
require 'winrm'

set :backend, :winrm
set :os, :family => 'windows'

opts = {
  endpoint: "http://#{ENV['KITCHEN_HOSTNAME']}:#{ENV['KITCHEN_PORT']}/wsman",
  transport: :plaintext,
  user: ENV['KITCHEN_USERNAME'],
  password: ENV['KITCHEN_PASSWORD'],
  basic_auth_only: true
}

Specinfra.configuration.winrm = WinRM::Connection.new(opts)


