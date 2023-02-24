require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'sinatra/json'
require 'json'
require_relative './lib/helper_modules/data_formatters'
require_relative './lib/payload'

module WebHookMessages

  STATUS = { 
    true => [200, :valid],
    false => [400, :invalid],
  }

  MESSAGE = {
    valid: 'Webhook data stored successfully',
    invalid: 'Error: invalid event data',
    invalid_payload: 'Error: invalid JSON payload',
    absent_data: {message: "No data available"}.to_json
  }

  def web_response(code, message)
    status code 
    MESSAGE[message]
  end


end

set :database, {adapter: "sqlite3", database: "eventwebhook.sqlite3"}

# this is now a proper model
class Event < ActiveRecord::Base

  include WebHookMessages

  self.table_name = 'events'
  
  def self.memory
    all.tap { |a| a.empty? and return MESSAGE[:absent_data] }
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

  include WebHookMessages

  configure :development do
    register Sinatra::Reloader
  end

  post '/event' do
      payload = Payload.new(request.body.read)
      data = Event.create(payload.process)

      web_response(*STATUS[data.valid?])

  rescue JSON::ParserError => e

      web_response(400, :invalid_payload)

  end

  get '/' do

    response['Content-Type'] = 'application/json'
    result_data = JSON.parse(Event.actions_and_records)

    JSON.pretty_generate result_data 

  end

end
