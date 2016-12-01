require 'rake'
require 'rake_performance'
require 'find'
require 'fileutils'
require "bundler/setup"

# always destroy the kitchen when running within Teamcity
destroy_strategy = ENV['TEAMCITY_VERSION'] ? 'always' : 'passing'
color = ENV['TEAMCITY_VERSION'] ? '--no-color' : '--color'
ENV['PUPPET_COLOR'] = '--color false' if ENV['TEAMCITY_VERSION']
rootdir = File.dirname(__FILE__)
ENV['SSL_CERT_FILE'] = "#{rootdir}/cacert.pem" unless ENV['SSL_CERT_FILE']

namespace :acceptance do
  task :prerequisites do
    raise 'Environment variable SQLSERVER2016_ISO_URL must be set to be able to run our acceptance tests' unless ENV['SQLSERVER2016_ISO_URL']
  end

  desc 'Install puppet modules from Puppetfile'
  task :installpuppetmodules do
    sh "bundle exec r10k puppetfile install --verbose"
  end

  desc 'Execute the acceptance tests'
  task :kitchen => [:prerequisites, :installpuppetmodules] do |task, args|
    begin
      Dir.mkdir('.kitchen') unless Dir.exist?('.kitchen')
      sh "kitchen test --destroy=#{destroy_strategy} --concurrency 2 --log-level=info #{color} 2> .kitchen/kitchen.stderr" do |ok, res|
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
      Dir.glob('**/*.pp').each do |puppet_file|
        Bundler.with_clean_env  do
          # Use bundler.with_clean_env as the way bundler set ruby environment variables
          # is killing puppet on windows.
          sh "puppet parser validate #{puppet_file}"
        end
      end
    end

    require 'puppet-lint/tasks/puppet-lint'
    Rake::Task[:lint].clear
    desc 'puppet-lint all the manifests'
    PuppetLint::RakeTask.new :lint do |config|
      # # Pattern of files to ignore
      # config.ignore_paths = ['modules/apt', 'modules/stdlib']

      # List of checks to disable
      config.disable_checks = ['80chars', 'trailing_whitespace', '2sp_soft_tabs', 'hard_tabs']

      # # Enable automatic fixing of problems, defaults to false
      # config.fix = true
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

task :checks => ['check:manifests:syntax', 'check:manifests:lint', 'check:ruby:syntax']
task :default => :checks
