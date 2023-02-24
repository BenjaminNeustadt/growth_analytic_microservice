require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'sinatra/json'
require 'json'

module Attributions

  module PageViews_assets

    def data
      @data
    end

    def fingerprint
    data['fingerprint']
    end

    def user_id
      data['user_id']
    end

    def url
      data['url']
    end

    def referrer_url
      data['referrer_url']
    end

    def created_at
      data['created_at']
    end

  end

end

 class Payload
 
  include Attributions
 
   private
 
   def initialize(data)
     @data = data
   end
 
   public
 
   attr_reader :data
 
   # def extract
   #   @data.keys.each_with_object({}) { |item, keyword_arguments| keyword_arguments[item.intern] = @data[item] }
   # end

   def extract_views
     {
       fingerprint:    fingerprint,
       user_id:        user_id ,
       url:            url,
       referrer_url:   referrer_url,
       created_at:     created_at
     }
   end

  end

set :database, {adapter: "sqlite3", database: "webhook-app.sqlite3"}

class View < ActiveRecord::Base
end

class WebhookApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  post '/event' do
    payload = Payload.new(JSON.parse(request.body.read))
    View.create(payload.extract_views)
  end

  get '/' do
    views = View.all
    response['Content-Type'] = 'application/json'
    JSON.pretty_generate(JSON.parse(views.to_json)).to_s
  end

end
