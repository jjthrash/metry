require 'rubygems'
require 'hoe'

Hoe.spec 'metry' do
  developer('Nathaniel Talbott', 'nathaniel@terralien.com')
  self.rubyforge_name = 'terralien'
end

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

task :test => [:basic_features, :radiant_features]