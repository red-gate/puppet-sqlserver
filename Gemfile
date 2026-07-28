source 'https://rubygems.org'

gem 'hiera-eyaml' # used to encrypt hiera data

gem 'kitchen-zip', :git => 'https://github.com/red-gate/kitchen-zip', :branch => 'master'

gem 'test-kitchen', '< 4.1.0' # pin to pre 4.1.0 until https://github.com/test-kitchen/test-kitchen/pull/2083 / https://github.com/test-kitchen/test-kitchen/issues/2082 is resolved

gem 'kitchen-puppet'
gem 'kitchen-vagrant', :git => 'https://github.com/njhowell/kitchen-vagrant', :branch => 'main'

# We use serverspec to test the state of our servers
gem 'serverspec', '~> 2'

gem 'locale', '< 2.1.5' # pin to pre 2.1.5 which introduced a change that depends on fiddle, which fails to install

gem 'winrm'

gem 'puppet-lint'
gem 'rubocop'
gem 'yamllint'


gem 'rake', '~> 13'
# This gem tells us how long each rake task takes.
gem 'rake-performance'

gem 'ra10ke' # Add rake tasks to manage puppetfile

gem 'r10k', '~> 3'
