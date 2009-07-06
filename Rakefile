require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:basic_features) do |t|
  t.fork = true
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'pretty')]
end

desc "Run Radiant features with Cucumber"
task :radiant_features do
  Dir.chdir(File.dirname(__FILE__) + "/radiant/example") do
    Cucumber::Rake::Task::ForkedCucumberRunner.new([], Cucumber::BINARY, [], FileList["features/**/*.feature"]).run
  end
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "lib"
end

task :default => [:test, :basic_features, :radiant_features]