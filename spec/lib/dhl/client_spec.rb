# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

  let(:client) { Dhl.client(username: 'username', password: 'password', account: 123456789) }

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
      response[:tracking_numbers].should == ["JD012038742880323158", "JD012038742880323159"]
      File.exists?('labels/9085882330.pdf').should be_true
    end
  end

  describe '#track' do
    before do
      VCR.insert_cassette 'tracking', record: :new_episodes
    end

    context 'the shipment has been fully delivered' do
      let(:response) { client.track ["5223281416"] }

      it 'should provide a track response with shipment info' do
        response.shipment_info.should_not be_nil
      end

      it 'should provide one or more events' do
        response.should have_at_least(1).event
      end

      subject { response }
      it { should be_delivered }

    end
  end

end
