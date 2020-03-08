# frozen_string_literal: true

require 'sinatra/base'
require 'require_all'
require_all './lib/generators'

# APP
class App < Sinatra::Base
  get '/' do
    'Amon Ra API Generator'
  end

  post '/' do
    generator(params[:framework]).new(params)
    200
  end

  private

  def generator(framework)
    case framework
    when 'RailsAPI'
      Generators::RailsAPI
    when 'SinatraBasic'
      Generators::SinatraBasic
    when 'Rust'
      Generators::Rust
    when 'Elixir'
      Generators::Elixir
    end
  end
end
