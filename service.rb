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
  
  def self.memory
    all
  end

  def self.trials_count
     where(name: 'trial').count
  end

  def self.signups_count
     where(name: 'signup').count
  end

  def self.unsubscribe_count
     where(name: 'unsubscribe').count
  end

  def self.trial_users
    where(name: 'trial')
  end

  def self.signup_users
    where(name: 'signup', user_id: trial_users.pluck(:user_id))
  end

  def self.actions_and_records
    {
      actions: {
        trials: trials_count,
        signups: signups_count,
        'trial-to-signup-conversion': signup_users.count,
        unsubscribe: unsubscribe_count
      },
      records: memory
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

    events      = Event.memory
    result_data = Event.actions_and_records

    if events.empty?
      { message: "No data available" }.to_json
    else
      JSON.pretty_generate(JSON.parse(result_data))
    end

  end

end
