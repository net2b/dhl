# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

  # let(:client) { Dhl.client(username: 'username', password: 'password', account: 123456789) }

let(:client) { Dhl.client(username: 'antoniolisrl', password: 'f4$H1()n', account: 105315001) }
  after do
    VCR.eject_cassette
  end

  describe '#request_shipment' do
    before do
      VCR.insert_cassette 'shipment', record: :new_episodes
    end

    let(:shipment_request) { Dhl::ShipmentRequest.new }
    let(:shipper) { FactoryGirl.build(:contact) }
    let(:recipient) { FactoryGirl.build(:contact) }
    let(:packages) { shipment_request.packages }
    let(:shipment) { FactoryGirl.build(:shipment) }

    it "should return a PDF shipping label" do
      shipment_request.shipper = shipper
      shipment_request.recipient = recipient
      shipment.pickup_time = (Time.now + 86400)
      shipment_request.shipment = shipment

      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      response = client.request_shipment(shipment_request)
      response[:tracking_number].should == '9085882330'
      File.exists?('labels/9085882330.pdf').should be_true
    end
  end

  describe '#track' do
    # before do
    #   VCR.insert_cassette 'tracking', record: :new_episodes
    # end

    it "should give back a tracking status" do
      response = client.track "9085882330"
      response[:tracking_response][:awb_info][:array].should_have 1.item


    end
  end

end
