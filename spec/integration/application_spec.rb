require 'spec_helper'
require 'rack/test'
require_relative '../../app/controllers/growth_analytic_controller.rb'
require 'database_cleaner'

RSpec.describe GrowthAnalyticController do

  include Rack::Test::Methods

  let(:app) { GrowthAnalyticController.new}

  context "GET to /" do
    it "returns 200 OK with empty data" do

      response = get('/')
      expect(response.status).to eq(200)
    end

    it "returns empty data initially" do
      response = get('/')
      result_data = <<~EOS
        {
          "actions": {
            "trials": 0,
            "signups": 0,
            "trial-to-signup-conversion": 0,
            "unsubscribe": 0
          },
          "records": "No data available"
        }
        EOS
      expect(response.body).to eq(result_data.chomp)
    end
  end

  context "POST to '/event'" do

    describe 'HTTP responses' do

      it "STATUS OK (200)" do

        payload_packet =
        {
          "name": "signup",
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f6606",
          "user_id": "6666bd053866341d6ad30000",
          "created_at": "2023-01-18 12:33:41.127641 UTC"
        }
        response = post('/event', payload_packet.to_json)

        expect(response.status).to eq(200)
      end

      it "STATUS invalid JSON format (400)" do

        payload_packet =
        {
          "name": "signup",
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f6606",
          "user_id": "6666bd053866341d6ad30000",
          "created_at": "2023-01-18 12:33:41.127641 UTC"
        }
        response = post('/event', payload_packet)

        expect(response.status).to eq(400)
      end
    end

    describe 'response BODY messages' do
    
      it "must respond with 'success' confirmation" do

        payload_packet =
        {
          "name": "signup",
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f6606",
          "user_id": "6666bd053866341d6ad30000",
          "created_at": "2023-01-18 12:33:41.127641 UTC"
        }

        response = post('/event', payload_packet.to_json)
        expect(response.body).to eq("Webhook data stored successfully")
      end

      it "must respond with 'invalid format' confirmation" do

        payload_packet =
        {
          "name": "signup",
          "fingerprint": "b998efcb-1af3-4149-9b56-34c4482f6606",
          "user_id": "6666bd053866341d6ad30000",
          "created_at": "2023-01-18 12:33:41.127641 UTC"
        }

        response = post('/event', payload_packet)
        expect(response.body).to eq("Error: invalid JSON payload")
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
