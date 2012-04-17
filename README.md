# Simple Goliath app that proxies http requests for file download and logs those file request into DB.

## Requirement

 - Goliath - for proxing app
 - Sinatra - for statistics front-end
 - RubyGems, ActiveRecord, EM-Synchrony
 - MySQL

## Basic architecture
The app is supposed to log http requests for files coming from http server and then redirect request to another url to get actual file. Request should be in format:

    <protocol>://<ur>l/<file_name>?uuid=<some_unique_string>

for example:

    http://xxx.com/credit_card_unlocker.exe?uuid=1234567890

## Configuration
Two config files are expected in 'config/':

 - `datababase.yml` - db config
 - `services.yml`   - config for proxy redirect, currently contains only `proxy_redirect_url` parameter to set url for redirecting after a request gets logged.

To setup the app run the following:

    bundle install
    rake db:create
    rake db:migrate

## Runnig the app
To get started easily there are:

    run_app.sh
    run_srv.sh

to run corresponding modules.

All file requests get logged into DB table with following fields:

  - `id`
  - `uuid` (some identifier that allows to differ uniqueness of a download)
  - `ip_address`
  - `file_name`
  - `created_at`

All collected statistics in plain representation are available through Sinatra-based front-end.
