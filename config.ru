# require 'sprockets'

require File.expand_path('../config/environment', __FILE__)

# prefix = '/thirty_one'
# 
# map(prefix) do
# end
# 
# # Redirect any requests for the root to /thirty_one/
# map('/') do
#   run lambda { |env| 
#     destination  = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
#     destination << "/thirty_one/"
#     destination << "?#{env['QUERY_STRING']}" unless env['QUERY_STRING'].empty?
#     [302, {'Location' => destination, 'Content-Type' => 'text/plain'}, ['You are being redirected']]
#   }
# end

map '/assets' do
  run ThirtyOne.sprockets_environment
end

map '/' do
  run ThirtyOne::App
end
