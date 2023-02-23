require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "webhook-app.sqlite3"}

class WebhookApp < Sinatra::Base


  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    info = File.read("events.json")

    @data = JSON.parse(info)
    erb :show
  end

  post '/event' do

    status 204
    request.body.rewind
    request_payload = request.body.read

    File.open("events.json", "a") do |f|
      f.puts(request_payload)
    end

  end

end
