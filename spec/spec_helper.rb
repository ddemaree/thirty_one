ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require "rack/test"
require 'active_support/core_ext/kernel'

schema_file = ENV['SCHEMA'] || "#{APP_ROOT}/db/schema.rb"
if File.exists?(schema_file)
  load(schema_file)
end

RSpec.configure do |c|
  c.before(:suite) do
    quietly do
      ActiveRecord::Migrator.migrate( File.join(APP_ROOT, 'db', 'migrate') )
    end
  end
end