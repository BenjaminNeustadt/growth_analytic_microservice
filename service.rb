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

# this is now a proper model
class Event < ActiveRecord::Base
  self.table_name = 'events'
  
  def memory
    self.class.all
  end

  def trials_count
     self.class.where(name: 'trial').count
  end

  def signups_count
     self.class.where(name: 'signup').count
  end

  def unsubscribe_count
     self.class.where(name: 'unsubscribe').count
  end

  def trial_users
    self.class.where(name: 'trial')
  end

  def signup_users
    self.class.where(name: 'signup', user_id: trial_users.pluck(:user_id))
  end

  def actions_and_records
    {
      actions: {
        trials: trials_count,
        signups: signups_count,
        'trial-to-signup-conversion': signup_users.count,
        unsubscribe: unsubscribe_count
      },
      records: events
    }.to_json
  end

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

    response['Content-Type'] = 'application/json'
    events = Event.new

    if events.memory.empty?
      { message: "No data available" }.to_json
    else
      JSON.pretty_generate(JSON.parse(events.actions_and_records))
    end

  end

end
