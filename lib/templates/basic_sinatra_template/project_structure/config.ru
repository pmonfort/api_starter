# config.ru (run with rackup)
require 'active_support/inflector'

Dir['./api/**/*.rb'].each do |file|
  require file
end

API.constants.select { |c| API.const_get(c).is_a? Class }.each do |resource|
  map "/#{resource.to_s.downcase.pluralize}" do
    run API.const_get(resource)
  end
end
