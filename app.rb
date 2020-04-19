# frozen_string_literal: true

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
      RailsAPI::Generator
    when 'Sinatra'
      Sinatra::Generator
    when 'Rust'
      Rust::Generator
    when 'Elixir'
      Elixir::Generator
    end
  end
end
