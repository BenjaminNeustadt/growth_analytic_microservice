require_relative '../dependencies'

class GrowthAnalyticController < ApplicationController

  include EndPoints

  configure :development do
    register Sinatra::Reloader
  end

  register Routes

end
