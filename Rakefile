require 'rake'
require 'rake_performance'
require 'find'
require 'fileutils'
require 'bundler/setup'

# always destroy the kitchen when running within Teamcity
destroy_strategy = ENV['TEAMCITY_VERSION'] ? 'always' : 'passing'
color = ENV['TEAMCITY_VERSION'] ? '--no-color' : '--color'
ENV['PUPPET_COLOR'] = '--color false' if ENV['TEAMCITY_VERSION']
rootdir = File.dirname(__FILE__)
ENV['SSL_CERT_FILE'] = "#{rootdir}/cacert.pem" unless ENV['SSL_CERT_FILE']

namespace :acceptance do
  task :prerequisites do
    raise 'Environment variable KITCHEN_YAML should be set to either .kitchen.oldsqlservers.yml, .kitchen.sqlservers.yml or .kitchen.ssms.yml' unless ENV['KITCHEN_YAML']

    case ENV['KITCHEN_YAML']
    when '.kitchen.oldsqlservers.yml'
      raise 'Environment variable SQLSERVER2005_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2005_ISO_URL']
    when '.kitchen.sqlservers.yml'
      raise 'Environment variable SQLSERVER2008_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2008_ISO_URL']
      raise 'Environment variable SQLSERVER2008R2_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2008R2_ISO_URL']
      raise 'Environment variable SQLSERVER2012_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2012_ISO_URL']
      raise 'Environment variable SQLSERVER2014_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2014_ISO_URL']
      raise 'Environment variable SQLSERVER2016_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2016_ISO_URL']
      raise 'Environment variable SQLSERVER2017_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2017_ISO_URL']
      raise 'Environment variable SQLSERVER2019_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2019_ISO_URL']
      raise 'Environment variable SQLSERVER2022_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2022_ISO_URL']
    end
  end

  desc 'Install puppet modules from Puppetfile'
  task :installpuppetmodules do
    sh 'bundle exec r10k puppetfile install --verbose'
  end

  desc 'Execute the acceptance tests'
  task kitchen: [:prerequisites, :installpuppetmodules] do
    begin
      Dir.mkdir('.kitchen') unless Dir.exist?('.kitchen')
      sh "kitchen test --destroy=#{destroy_strategy} --concurrency 3 --log-level=info #{color} 2> .kitchen/kitchen.stderr" do |ok, _|
        raise IO.read('.kitchen/kitchen.stderr') unless ok
      end
    ensure
      puts "##teamcity[publishArtifacts '#{Dir.pwd}/.kitchen/logs/*.log => logs.zip']"
    end
  end
end

namespace :check do
  namespace :manifests do
    desc 'Validate syntax for all manifests'
    task :syntax do
      Bundler.with_clean_env  do
        # Use bundler.with_clean_env as the way bundler set ruby environment variables
        # is killing puppet on windows.
        sh "puppet parser validate #{rootdir}"
      end
    end

    require 'puppet-lint/tasks/puppet-lint'
    Rake::Task[:lint].clear
    desc 'puppet-lint all the manifests'
    PuppetLint::RakeTask.new :lint do |config|
      # List of checks to disable
      config.disable_checks = %w(80chars trailing_whitespace 2sp_soft_tabs hard_tabs)

      config.relative = true
    end
  end

  namespace :ruby do
    desc 'Validate syntax for all ruby files'
    task :syntax do
      Dir.glob('**/*.rb').each do |ruby_file|
        sh "ruby -c #{ruby_file}"
      end
      Dir.glob('**/*.erb').each do |erb_file|
        sh "erb -P -x -T '-' #{erb_file} | ruby -c"
      end
    end
  end
end

task checks: ['check:manifests:syntax', 'check:manifests:lint', 'check:ruby:syntax']
task default: :checks
