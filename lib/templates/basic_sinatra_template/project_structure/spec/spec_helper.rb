# frozen_string_literal: true

ENV['SINATRA_ENV'] = 'test'

Bundler.require(:default, ENV['SINATRA_ENV'])

require 'faker'
require 'rack/test'

ActiveRecord::Base.logger = nil

require File.expand_path '../../app.rb', __FILE__
module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
    FactoryBot.find_definitions
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end
