require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/reloader'
require 'json'

[
  '/../../lib',
  '/../../lib/helpers',
  '/../../config',
  '/.',
  '/../models'
].each { |path| $LOAD_PATH << File.expand_path(File.dirname(__FILE__)) + path}

require 'data_formatters'
require 'endpoints'
require 'event'
require 'payload'
require 'routes'
require 'application_controller'

# This is the Application Controller
class GrowthAnalyticController < ApplicationController

  include EndPoints

  configure :development do
    register Sinatra::Reloader
  end

  register Routes

end
