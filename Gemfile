source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.0.0'
  gem 'rspec', '~> 3.4.0'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper', '~> 1.2.1'
  gem 'metadata-json-lint'
  gem 'rspec-puppet-facts'
  gem 'simplecov', '>=0.11.0'
  gem 'rubocop', '0.40.0'
  gem 'puppet-lint', '~> 2.0'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'rb-readline'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
end
