# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :spec do
  RSpec::Core::RakeTask.new :html do |rspec|
    rspec.name = "spec::html"
    rspec.rspec_opts = %w(--format html --out .report/rspec_test_report.html)
  end
end