# frozen_string_literal: true

require 'sinatra/base'

# RaAPI APP
class RaAPI < Sinatra::Base
  get '/' do
    'Ra API Generator'
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
