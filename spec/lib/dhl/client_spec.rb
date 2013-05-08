# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

  before do
    VCR.insert_cassette 'shipment', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  let(:client) { Dhl.client(username: 'username', password: 'password', account: 123456789) }
  let(:shipment_request) { Dhl::ShipmentRequest.new }
  let(:shipper) { FactoryGirl.build(:contact) }
  let(:recipient) { FactoryGirl.build(:contact) }
  let(:packages) { shipment_request.packages }
  let(:shipment) { FactoryGirl.build(:shipment) }

  describe '#request_shipment' do
    it "should return a PDF shipping label" do
      shipment_request.shipper = shipper
      shipment_request.recipient = recipient
      shipment.pickup_time = (Time.now + 86400)
      shipment_request.shipment = shipment

      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      response = client.request_shipment(shipment_request)
      response[:tracking_numbers].should == ["JD012038742880323158", "JD012038742880323159"]
      File.exists?('labels/9085882330.pdf').should be_true
    end
  end

end
