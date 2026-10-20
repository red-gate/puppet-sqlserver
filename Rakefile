require 'rake'
require 'rake_performance'
require 'find'
require 'fileutils'
require 'bundler/setup'
require 'open3'

# Escape a value for use in a Teamcity service message.
# See https://www.jetbrains.com/help/teamcity/service-messages.html#Escaped+Values
def teamcity_escape(value)
  value.to_s.gsub(/[|'\[\]\n\r]/, '|' => '||', "'" => "|'", '[' => '|[', ']' => '|]', "\n" => '|n', "\r" => '|r')
end

# Write a Teamcity service message. Does nothing when we're not running within Teamcity.
def teamcity_message(name, attributes)
  return unless ENV['TEAMCITY_VERSION']
  attributes = attributes.map { |key, value| "#{key}='#{teamcity_escape(value)}'" }.join(' ')
  puts "##teamcity[#{name} #{attributes}]"
end

# Run `kitchen test` for a single instance, retrying it if it fails, and report it to Teamcity as a test.
# Returns true if the instance passed.
def kitchen_test_instance(instance, retries:, destroy_strategy:, color:)
  teamcity_message('testStarted', name: instance, captureStandardOutput: 'true')

  attempts = retries + 1
  errors = ''
  passing_attempt = (1..attempts).find do |attempt|
    puts "Testing #{instance} (attempt #{attempt} of #{attempts})"
    stderr_file = ".kitchen/#{instance}.attempt#{attempt}.stderr"
    passed = false
    # Use test and let kitchen handle the destroy, create, converge, setup, verify, destroy workflow
    sh "kitchen test #{instance} --destroy=#{destroy_strategy} --log-level=info #{color} 2> #{stderr_file}" do |ok, _|
      passed = ok
      errors = IO.read(stderr_file) unless ok
    end
    passed
  end

  if passing_attempt.nil?
    warn errors
    # Let's show some nicer teamcity errors for quicker troubleshooting
    error_lines = errors.split("\n").select { |line| line.include?('failed on instance') || line.include?('Failed to complete') }
    error_lines.each { |line| teamcity_message('buildProblem', description: line) }
    teamcity_message('testFailed', name: instance, message: error_lines.first || "kitchen test failed for #{instance}", details: errors)
  elsif passing_attempt > 1
    puts "#{instance} passed on attempt #{passing_attempt} of #{attempts}"
    teamcity_message('message', text: "#{instance} failed, then passed on attempt #{passing_attempt} of #{attempts}", status: 'WARNING')
  end

  teamcity_message('testFinished', name: instance)
  !passing_attempt.nil?
end

# always destroy the kitchen when running within Teamcity
destroy_strategy = ENV['TEAMCITY_VERSION'] ? 'always' : 'passing'
color = ENV['TEAMCITY_VERSION'] ? '--no-color' : '--color'
ENV['PUPPET_COLOR'] = '--color false' if ENV['TEAMCITY_VERSION']
rootdir = File.dirname(__FILE__)
ENV['SSL_CERT_FILE'] = "#{rootdir}/cacert.pem" unless ENV['SSL_CERT_FILE']
# Don't buffer our output, so it stays in order with the output of the commands we run
# (and Teamcity service messages wrap the right output).
$stdout.sync = true

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
    # How many times to retry an instance that fails, to get past transient errors.
    # Defaults to no retries outside Teamcity, as a retry destroys the failed instance you might want to debug.
    retries = Integer(ENV['KITCHEN_RETRIES'] || (ENV['TEAMCITY_VERSION'] ? 1 : 0))
    suitename = File.basename(ENV['KITCHEN_YAML'], '.yml').sub(/\A\.kitchen\./, '')

    begin
      Dir.mkdir('.kitchen') unless Dir.exist?('.kitchen')

      # Test each instance on its own, so that we can retry just the ones that fail
      # and report each one to Teamcity as a separate test.
      output, status = Open3.capture2('kitchen list --bare')
      raise "Failed to list the kitchen instances in #{ENV['KITCHEN_YAML']}" unless status.success?
      instances = output.split("\n").map(&:strip).select { |line| line.match?(/\A[\w-]+\z/) }
      raise "No kitchen instances found in #{ENV['KITCHEN_YAML']}" if instances.empty?

      teamcity_message('testSuiteStarted', name: suitename)
      failed = instances.reject do |instance|
        kitchen_test_instance(instance, retries: retries, destroy_strategy: destroy_strategy, color: color)
      end
      teamcity_message('testSuiteFinished', name: suitename)

      raise "Kitchen tests failed for: #{failed.join(', ')}" unless failed.empty?
    ensure
      puts "##teamcity[publishArtifacts '#{Dir.pwd}/.kitchen/logs/*.log => logs.zip']"
    end
  end
end

namespace :check do
  namespace :manifests do
    desc 'Validate syntax for all manifests'
    task :syntax do
      sh "puppet parser validate #{rootdir}"
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
