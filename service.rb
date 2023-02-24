require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'sinatra/json'
require 'json'
require_relative './lib/helper_modules/data_formatters'
require_relative './lib/payload'


set :database, {adapter: "sqlite3", database: "eventwebhook.sqlite3"}

class Event < ActiveRecord::Base
  self.table_name = 'events'
end

class EventWebhookApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  post '/event' do
    begin

      payload = Payload.new(JSON.parse(request.body.read))
      data = Event.create(payload.process)
      data.valid? ? (status 200 ; 'Webhook data stored successfully') : (status 400 ; 'Error: invalid event data')

    rescue JSON::ParserError => e
      status 400
      'Error: invalid JSON payload'
    end

  end

  get '/' do

    # Everything below can be extracted elsewhere?
    trials_count = Event.where(name: 'trial').count
    signups_count = Event.where(name: 'signup').count
    unsubscribe_count = Event.where(name: 'unsubscribe').count

    trial_users = Event.where(name: 'trial')
    signup_users = Event.where(name: 'signup', user_id: trial_users.pluck(:user_id))

    result = {
      actions: {
        trials: trials_count,
        signups: signups_count,
        'trial-to-signup-conversion': signup_users.count,
        unsubscribe: unsubscribe_count
      },
      records: Event.all
    }

    views = Event.all
    response['Content-Type'] = 'application/json'

    if views.empty?
      { message: "No data available" }.to_json
    else
      JSON.pretty_generate(JSON.parse(result.to_json))
    end
  end

end
