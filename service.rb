require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'sinatra/json'
require 'json'

module Attributions

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

  def name
    data['name']
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
 
  def process
   data.key?("name") ? process_event : process_view
  end

  def process_view
    {
      fingerprint:    fingerprint,
      user_id:        user_id ,
      url:            url,
      referrer_url:   referrer_url,
      created_at:     created_at
    }
  end

  def process_event
    {
      name:           name,
      fingerprint:    fingerprint,
      user_id:        user_id ,
      created_at:     created_at
    }
  end

end


set :database, {adapter: "sqlite3", database: "eventwebhook.sqlite3"}

class Event < ActiveRecord::Base
end

class EventWebhookApp < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  post '/event' do
    begin

      payload = Payload.new(JSON.parse(request.body.read))
      data = Event.create(payload.process_event)

      if data.valid?
        status 200
        'Webhook data stored successfully'
      end

    rescue JSON::ParserError => e
    # Return an error response for invalid JSON payload
      status 400
      'Error: invalid JSON payload'
    end

  end

  get '/' do
    views = Event.all
    response['Content-Type'] = 'application/json'
    if views.empty?
      { message: "No data available" }.to_json
    else
      JSON.pretty_generate(JSON.parse(views.to_json)).to_s
    end
  end

end

# def extract
#   @data.keys.each_with_object({}) { |item, keyword_arguments| keyword_arguments[item.intern] = @data[item] }
# end