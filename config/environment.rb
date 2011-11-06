ENV['RACK_ENV'] ||= 'development'

APP_ROOT = File.expand_path("../../", __FILE__)

require 'bundler'
Bundler.setup
Bundler.require :default, ENV['RACK_ENV']

$:<< File.join( APP_ROOT )
$:<< File.join( APP_ROOT, "lib" )

begin
  require 'active_record'
  dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
rescue => e
  puts "Could not establish ActiveRecord connection: #{e}"
end

require "thirty_one"