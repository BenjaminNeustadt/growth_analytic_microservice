require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/reloader'
require 'json'

[
  '/../config',
  '/helpers',
  '/controllers',
  '/models'
].each { |path| $LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + path}

require 'data_formatters'
require 'endpoints'
require 'event'
require 'payload'
require 'routes'
require 'application_controller'
