require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/reloader'
require 'json'

[
  '/../lib',
  '/../lib/helpers',
  '/controllers',
  '/models'
].each { |path| $LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + path}

require 'data_formatters'
require 'endpoints'
require 'event'
require 'payload'

# This is the Application Controller
class GrowthAnalytic < Sinatra::Base

  include EndPoints

  configure :development do
    register Sinatra::Reloader
  end

  post('/event') {event_webhook}

  get('/') {event_endpoint}

end
