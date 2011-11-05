task :environment do
  require File.expand_path( "../config/environment", __FILE__ )
end

# begin
#   require 'rspec/core/rake_task'
#   RSpec::Core::RakeTask.new
# rescue => e
#   puts "RSpec tasks not available in production"
# end

task :default => [:spec]

namespace :assets do
  def precompiled_assets
    [].tap do |arr|
      arr.concat Dir[File.join(APP_ROOT, "assets", "images", "*")].map { |f| File.basename(f)  }
      arr << "thirty_one.css"
      arr << "application.js"
    end
  end
  
  task :precompile => :environment do
    target = File.join(APP_ROOT, "public", "assets")
    
    @_env = ThirtyOne.sprockets_environment
    @_env.each_logical_path do |logical_path|
      next unless precompiled_assets.include?(logical_path)
      if asset = @_env.find_asset(logical_path)
        puts "Precompile #{logical_path}"
        filename = File.join(target, asset.digest_path)
        FileUtils.mkdir_p File.dirname(filename)
        asset.write_to(filename)
        # asset.write_to("#{filename}.gz") if filename.to_s =~ /\.(css|js)$/
      end
    end
  end
end

namespace :db do
  desc "Migrate the database"
  task :migrate => [:environment] do
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate( File.expand_path("../db/migrate", __FILE__) )
  end
  
  namespace :schema do
    desc "Create a db/schema.rb file that can be portably used against any DB supported by AR"
    task :dump => :environment do
      require 'active_record/schema_dumper'
      File.open(ENV['SCHEMA'] || "#{APP_ROOT}/db/schema.rb", "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
      Rake::Task["db:schema:dump"].reenable
    end

    desc "Load a schema.rb file into the database"
    task :load => :environment do
      file = ENV['SCHEMA'] || "#{APP_ROOT}/db/schema.rb"
      if File.exists?(file)
        load(file)
      else
        abort %{#{file} doesn't exist yet. Run "rake db:migrate" to create it then try again. If you do not intend to use a database, you should instead alter #{APP_ROOT}/config/boot.rb to limit the frameworks that will be loaded}
      end
    end
  end
  
end
