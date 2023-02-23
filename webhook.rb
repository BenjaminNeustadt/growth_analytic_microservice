require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require 'sinatra/json'
require 'json'

# class Payload
# 
#   # include Attributions
# 
#   private
# 
#   def initialize(data)
#     @data = data
#   end
# 
#   public
# 
#   attr_reader :data
# 
#   # def extract
#   #   @data.to_json
#   #   # @data.keys.each_with_object({}) { |item, keyword_arguments| keyword_arguments[item.intern] = @data[item] }
#   # end
# 
# 
# end
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

end


set :database, {adapter: "sqlite3", database: "webhook-app.sqlite3"}

class View < ActiveRecord::Base
end

class WebhookApp < Sinatra::Base
 include Attributions

  configure :development do
    register Sinatra::Reloader
  end

  #include Attributions

  post '/event' do
    # puts '+-' * 15
    # p( JSON.parse(request.body.read))
    # puts '+-' * 15

    @data = JSON.parse(request.body.read)
    #payload = Payload.new(JSON.parse(request.body.read))
    # fingerprint  = data['fingerprint']
    # user_id      = data['user_id']
    # url          = data['url']
    # referrer_url = data['referrer_url']
    # created_at   = data['created_at']

     View.create(
       fingerprint:    fingerprint,
       user_id:        user_id ,
       url:            url,
       referrer_url:   referrer_url,
       created_at:     created_at
    )
  end

    #View.create(payload.extract)
    #redirect '/'
    # Do we really need to redirect to the index exposing the API,
    # or rather do we need to redirect back to the site they were aiming for

  get '/' do
    @data = View.all.to_json
    erb :show
  end

end


  # get '/api_exposed_endpoint' do
  #   @info = View.all.to_json
  #   erb :show
  # end

# class for extracting the attributions of a payload


  # <1>

=begin

dont lose attribution <1>
@payload.keys.each_with_object({}) { |item, keyword_arguments| keyword_arguments[item.intern] = @payload[item].to_s }

we normalize the payload keys to symbols, however, the problem we still have is that we can't input anything that isn't part of the schema yet.
If the schema is limiting what we are able to store, we switch it out to a non relational database.
To work around this we could work with a no sql database like mongodb. using an ORM in this case is favourable, as we simply need to switch the database.


fingerprint  = payload['fingerprint']
user_id      = payload['user_id']
url          = payload['url']
referrer_url = payload['referrer_url']
created_at   = payload['created_at']

 this currently does not allow for extraneous attribution to be stored
 this is based on the example data given and does not go outside of that box

=end

=begin
require 'json'

input = "{\n  fingerprint: \"67\",\n  user_id: \"86\",\n  url: \"https://www.bleenny.com/en\",\n  referrer_url: \"google.com\",\n  created_at: \"2025-01-20 13:59:56.437947 UTC\"\n}"

# Remove newlines and replace colons with double quotes to make the input a valid Ruby hash
input.gsub!(/[\n:]/, '').gsub!(/(\w+)\s/, '"\1": ')

# Parse the input as a Ruby hash
data = eval(input)

# Convert the hash to a JSON string
json_string = JSON.dump(data)

puts json_string

=end