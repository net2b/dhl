# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

  let(:client) { Dhl.client }
  subject { response }

  describe '#request_shipment' do
    let(:shipment_request) { Dhl::ShipmentRequest.new }
    let(:shipper) { FactoryGirl.build(:contact) }
    let(:recipient) { FactoryGirl.build(:contact) }
    let(:packages) { shipment_request.packages }
    let(:shipment) { FactoryGirl.build(:shipment) }
    let(:response) { client.request_shipment(shipment_request) }

    it "should be valid" do
      shipment_request.shipper = shipper
      shipment_request.recipient = recipient
      shipment.pickup_time = (Time.now + 86400)
      shipment_request.shipment = shipment
      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      VCR.use_cassette('request_shipment') do
        tracking_number = response[:tracking_number]

        tracking_number.should =~ /\w{10}/ # 10 chars tracking number
        File.exists?("labels/#{tracking_number}.pdf").should be_true
      end

      # Still not sure how to test tracking info
      # tracking_response = client.track(tracking_number)
      # tracking_response.shipment_info.should_not be_nil
      # tracking_response.should have_at_least(1).event
      # tracking_response.should be_delivered
    end
  end
end
