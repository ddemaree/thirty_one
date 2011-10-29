ENV['RACK_ENV'] ||= 'development'

APP_ROOT = File.expand_path("../../", __FILE__)

require 'bundler'
Bundler.setup
Bundler.require :default, ENV['RACK_ENV']

$:<< File.join( APP_ROOT )
$:<< File.join( APP_ROOT, "lib" )

require 'active_record'
dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]

require "thirty_one"