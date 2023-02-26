require 'spec_helper'
require 'rack/test'
require_relative '../app/models/payload'
require 'database_cleaner'

RSpec.describe Payload do
  include Rack::Test::Methods

  context "knows what to do with data" do
    it "parses incoming JSON data" do
      incoming_data ='{
        "name": "signup",
        "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f62456",
        "user_id": "6666bd053866341d6ad30020091",
        "created_at": "2023-01-18 12:32:41.127641 UTC"
      }' 
      payload = Payload.new(incoming_data)
      parsed_data =
      {
        "created_at"=>"2023-01-18 12:32:41.127641 UTC",
        "fingerprint"=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        "name"=>"signup",
        "user_id"=>"6666bd053866341d6ad30020091"
      }
      expect(payload.data).to eq parsed_data
    end

    describe "when the payload is a signup event" do
      it "should process data as an 'event' with name attribute" do
        incoming_data =
        '{
          "name": "signup",
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f62456",
          "user_id": "6666bd053866341d6ad30020091",
          "created_at": "2023-01-18 12:32:41.127641 UTC"
        }' 

        payload = Payload.new(incoming_data)

        processed_event =
        {
          :created_at=>"2023-01-18 12:32:41.127641 UTC",
          :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
          :name=>"signup",
          :user_id=>"6666bd053866341d6ad30020091"
        }

        expect(payload.process).to eq processed_event
        expect(payload.process).to include (:name)
        expect(payload.process).not_to include (:referrer_url)
      end
    end

    describe "when the payload is a pageview event" do
      it "should process data as a 'pageview' with referrer_url attribute" do

        incoming_data =
        '{
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f6606",
          "user_id": "null", 
          "url": "https://www.blinkist.com/en",
          "referrer_url": "https://www.google.de/",
          "created_at": "2023-01-20 13:59:56.437947 UTC"
        }'

        payload = Payload.new(incoming_data)

        processed_data = 
        {
          :created_at=>"2023-01-20 13:59:56.437947 UTC",
          :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f6606",
          :referrer_url=>"https://www.google.de/",
          :url=>"https://www.blinkist.com/en",
          :user_id=>"null"
        }

        expect(payload.process).to eq processed_data
        expect(payload.process).not_to include (:name)
        expect(payload.process).to include (:referrer_url)
      end
    end
  end
end