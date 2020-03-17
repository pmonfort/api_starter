# frozen_string_literal: true

ENV['SINATRA_ENV'] = 'test'

Bundler.require(:default, ENV['SINATRA_ENV'])

require 'faker'
require 'rack/test'

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end
