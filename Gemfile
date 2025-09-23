source 'https://rubygems.org'

gem 'puppet-lint'
gem 'puppet'

gem 'test-kitchen', '< 3.8.0' # pin to pre 3.8.0 which introduced a change to how it uploads files which breaks ssh_tgz upload in the kitchen-zip module above
gem 'kitchen-puppet', '>= 3.6.0'
gem 'kitchen-vagrant'

gem 'kitchen-zip', :git => 'https://github.com/red-gate/kitchen-zip', :branch => 'master'

# We use serverspec to test the state of our servers
gem 'serverspec', '~> 2'

# We use rake as our build engine
gem 'rake', '~> 13'
# This gem tells us how long each rake task takes.
gem 'rake-performance'

gem 'r10k', '~> 3'

gem 'ffi', '~> 1.15.0'
gem 'rexml'

