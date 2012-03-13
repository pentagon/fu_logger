require 'rubygems'
require 'sinatra'
require 'haml'
require 'active_record'
$: << '.'
require 'logged_file'

APP_ENV = ENV['APP_ENV'] || 'development'
db_config =  YAML::load(File.open 'config/database.yml')[APP_ENV]
ActiveRecord::Base.establish_connection db_config

get '/' do
  @files = LoggedFile.all
  haml :index
end
