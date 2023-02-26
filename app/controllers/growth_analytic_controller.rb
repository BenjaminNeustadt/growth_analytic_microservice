require_relative '../dependencies'
# This is the Application Controller
class GrowthAnalyticController < ApplicationController

  include EndPoints

  configure :development do
    register Sinatra::Reloader
  end

  register Routes

end
