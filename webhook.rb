require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'json'

set :database, {adapter: "sqlite3", database: "webhook-app.sqlite3"}

class View < ActiveRecord::Base
end

class WebhookApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @data = View.find_by(fingerprint: "0").to_json
    erb :show
  end

  post '/event' do

    payload = request.body.read

    fingerprint  = payload['fingerprint']
    user_id      = payload['user_id']
    url          = payload['url']
    referrer_url = payload['referrer_url']
    created_at   = payload['created_at']

    View.create(
      fingerprint:    fingerprint,
      user_id:        user_id ,
      url:            url,
      referrer_url:   referrer_url,
      created_at:     created_at
    )

    redirect '/'

  end

end
