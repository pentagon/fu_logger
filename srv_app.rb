require 'rubygems'
require 'active_record'
require 'goliath'
require 'em-synchrony/em-http'
$: << '.'
require 'logged_file'

APP_ENV = ENV['APP_ENV'] || 'development'
srv_config = YAML::load(File.open 'config/services.yml')[APP_ENV]
db_config =  YAML::load(File.open 'config/database.yml')[APP_ENV]
ActiveRecord::Base.establish_connection db_config
forwarder = srv_config['proxy_redirect_url']

class SrvApp < Goliath::API
  # use ::Rack::Reloader, 0 if Goliath.dev?
  use Goliath::Rack::Params

  def on_headers env, headers
    env.logger.info 'proxying new request: ' + headers.inspect
    env['client-headers'] = headers
  end

  def response env
    params = {head: env['client-headers'], query: env.params}
    log_file env
    file_name = env[Goliath::Request::REQUEST_PATH]
    req = EM::HttpRequest.new "#{forwarder}#{file_name}"

    resp = case env[Goliath::Request::REQUEST_METHOD]
      when 'GET'  then req.get params
      when 'POST' then req.post params.merge(body: env[Goliath::Request::RACK_INPUT].read)
      else p "UNKNOWN METHOD #{env[Goliath::Request::REQUEST_METHOD]}"
    end

    response_headers = {}
    resp.response_header.each_pair {|k, v| response_headers[to_http_header(k)] = v}
    [resp.response_header.status, response_headers, resp.response]
  end

  def to_http_header k
    k.downcase.split('_').collect {|e| e.capitalize}.join('-')
  end

  def log_file env
    file_name = env[Goliath::Request::REQUEST_PATH]
    uuid = env.params[:uuid]
    ip_address = env[Goliath::Request::REMOTE_ADDR]
    return if uuid.blank?

    EM.next_tick do
      LoggedFile.create(file_name: file_name, uuid: uuid, ip_address: ip_address)
    end
  end
end
