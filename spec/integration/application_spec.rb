require 'spec_helper'
require 'rack/test'
require_relative '../../app/growth_analytic'

describe GrowthAnalytic do

  include Rack::Test::Methods

  let(:app) { GrowthAnalytic.new}

  context "GET to /" do
    it "returns 200 OK" do

      response = get('/')
      expect(response.status).to eq(200)

    end
  end

end