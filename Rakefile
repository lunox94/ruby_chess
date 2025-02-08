# frozen_string_literal: true

require 'rake'

# Define paths
MAIN_FILE = 'bin/main.rb'
TEST_DIR  = 'spec'

desc 'Run the main Ruby script'
task :run do
  sh "bundle exec ruby #{MAIN_FILE}"
end

desc 'Run tests with RSpec'
task :test do
  sh "bundle exec rspec #{TEST_DIR}"
end

desc 'Clean up temporary files'
task :clean do
  sh 'rm -rf tmp/*' if Dir.exist?('tmp')
end

desc 'Set up the project (install dependencies)'
task :setup do
  sh 'bundle install'
end
