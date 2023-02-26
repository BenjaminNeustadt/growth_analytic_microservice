require 'spec_helper'
require 'rack/test'
require 'sinatra/activerecord'
require_relative '../app/helpers/webhookmessages'
require_relative '../app/models/event'

 RSpec.describe Event do
   include Rack::Test::Methods
 
  let(:event) { Event }

  context "Updating/reading the database" do

    it "increases the count of signup event by 1" do
      expect(event.signups_count).to eq 0 
      processed_event = 
      {
       :created_at=>"2023-01-18 12:32:41.127641 UTC",
       :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
       :name=>"signup",
       :user_id=>"6666bd053866341d6ad30020091"
      }
      new_payload_entry = event.create(processed_event)
      expect(event.signups_count).to eq 1
    end

    describe "distinguishing event types using 'name' attribute" do

      it "when the event is 'trial" do

        processed_event = 
        {
        :created_at=>"2023-01-18 12:32:41.127641 UTC",
        :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        :name=>"trial",
        :user_id=>"6666bd053866341d6ad30020091"
        }
        event.create(processed_event)
        expect(event.signups_count).to eq 0
        expect(event.trials_count).to eq 1
      end

      it "when the event is 'unsubscribe'" do

        expect(event.unsubscribe_count).to eq 0
        processed_event = 
        {
        :created_at=>"2023-01-18 12:32:41.127641 UTC",
        :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        :name=>"unsubscribe",
        :user_id=>"6666bd053866341d6ad30020091"
        }
        event.create(processed_event)
        expect(event.unsubscribe_count).to eq 1
      end
    end

    describe "allows an inventory of the database" do

      it "details how many of each event type is stored" do

        expect(event.unsubscribe_count).to eq 0
        expect(event.trials_count).to eq 0
        expect(event.signups_count).to eq 0

        trial_event = 
        {
        :created_at=>"2023-01-18 12:32:41.127641 UTC",
        :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        :name=>"trial",
        :user_id=>"6666bd053866341d6ad30020091"
        }

        signup_event = 
        {
        :created_at=>"2021-01-18 12:32:41.127641 UTC",
        :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        :name=>"signup",
        :user_id=>"6666bd053866341d6ad30020091"
        }

        unsubscribe_event = 
        {
        :created_at=>"2022-01-18 12:32:41.127641 UTC",
        :fingerprint=>"b998efcb-1af3-4149-9b56-34c4482f62456",
        :name=>"unsubscribe",
        :user_id=>"6666bd053866341d6ad30020091"
        }

        event.create(trial_event)
        event.create(signup_event)
        event.create(unsubscribe_event)

        expect(event.unsubscribe_count).to eq 1
        expect(event.trials_count).to eq 1
        expect(event.signups_count).to eq 1
      end

    end

    around do |example|
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.cleaning do
        example.run
      end
    end
   end
 
 end
