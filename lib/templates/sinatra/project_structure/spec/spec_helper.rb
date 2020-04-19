# frozen_string_literal: true

ENV['SINATRA_ENV'] = 'test'

require './config/environment'

require 'database_cleaner'
require 'factory_bot'
require 'faker'
require 'rack/test'
require 'rspec'

module RSpecMixin
  include FactoryBot::Syntax::Methods
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end
end
