$: << '.'

APP_ENV = ENV['APP_ENV'] || 'development'
DB_MIGRATIONS_PATH = ENV['DB_MIGRATIONS_PATH'] || 'db'

namespace :db do
  require 'setup'
  db_config = YAML::load(File.open 'config/database.yml')[APP_ENV]

  desc 'Create database'
  task :create do
    Setup.create_db db_config
  end

  desc 'Create table(s)'
  task :migrate do
    Setup.migrate db_config, DB_MIGRATIONS_PATH
  end

  desc 'Drop database'
  task :drop do
    Setup.drop_db db_config
  end
end
