# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
#require 'cucumber/rails/world'

# Comment out the next line if you don't want transactions to
# open/roll back around each scenario
# Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
# Cucumber::Rails.bypass_rescue

require 'test/unit/assertions'
World(Test::Unit::Assertions)

require 'rack/test'
World(Rack::Test::Methods)

$: << RAILS_ROOT + '/../../vendor/webrat/lib'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack_test
end

def app
  ActionController::Dispatcher.new
end

World(Webrat::Methods)
World(Webrat::Matchers)

Before do
  @__cucumber_ar_connection = ActiveRecord::Base.connection
  if @__cucumber_ar_connection.respond_to?(:increment_open_transactions)
    @__cucumber_ar_connection.increment_open_transactions
  else
    ActiveRecord::Base.__send__(:increment_open_transactions)
  end
  @__cucumber_ar_connection.begin_db_transaction
  ActionMailer::Base.deliveries = [] if defined?(ActionMailer::Base)
end

After do
  @__cucumber_ar_connection.rollback_db_transaction
  if @__cucumber_ar_connection.respond_to?(:decrement_open_transactions)
    @__cucumber_ar_connection.decrement_open_transactions
  else
    ActiveRecord::Base.__send__(:decrement_open_transactions)
  end
end
