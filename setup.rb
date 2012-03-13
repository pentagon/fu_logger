require 'rubygems'
require 'active_record'

class Setup
  class << self
    def create_db config
      ActiveRecord::Base.establish_connection config
      ActiveRecord::Base.connection
      rescue
        ActiveRecord::Base.establish_connection config.merge('database' => nil)
        ActiveRecord::Base.connection.create_database config['database']
        ActiveRecord::Base.establish_connection config
    end

    def migrate db_config, migrations_path
      ActiveRecord::Base.establish_connection db_config
      ActiveRecord::Migrator.up migrations_path
    end

    def drop_db db_config
      ActiveRecord::Base.establish_connection db_config
      ActiveRecord::Base.connection.drop_database db_config['database']
    end
  end
end
