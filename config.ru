# frozen_string_literal: true

# config.ru (run with rackup)
require './app/ra_api.rb'
require_all 'lib'
run RaAPI
