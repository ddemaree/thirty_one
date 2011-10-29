# require 'sprockets'

require File.expand_path('../config/environment', __FILE__)

map '/assets' do
  run ThirtyOne.sprockets_environment
end

map '/' do
  run ThirtyOne::App
end