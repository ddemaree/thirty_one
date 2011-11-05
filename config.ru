require 'bundler'
Bundler.setup

require File.expand_path('../config/environment', __FILE__)

map '/assets' do
  run ThirtyOne.sprockets_environment
end

map '/test' do
  run lambda { |e| [200, {"Content-Type" => "text/plain"}, ["Hello?"]]  }
end

map '/' do
  run ThirtyOne::App
end
