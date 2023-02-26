require 'spec_helper'
require 'rack/test'
require 'sinatra/activerecord'
require_relative '../app/helpers/webhookmessages'
require_relative '../app/models/pageview'

RSpec.describe PageView do
 include Rack::Test::Methods

 let(:pageview) { PageView }

 context "Updating/reading the database" do

   it "increases the count of pageview event by 1" do
     expect(pageview.all.count).to eq 0 

     pageview_event = 
     {
       fingerprint: "b998efcb-1af3-4149-9b56-34c4482f6606",
       user_id: "nil",
       url: "https://www.blinkist.com/en",
       referrer_url: "nil",
       created_at: "2023-01-20 13:59:56.437947 UTC"
     }
     pageview.create(pageview_event)
     expect(pageview.all.count).to eq 1
   end
 end

end