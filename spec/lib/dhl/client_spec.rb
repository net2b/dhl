# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do
  stub_dhl_env_variables!

  let(:client) { Dhl::Client.new }
  subject { response }

  after do
    VCR.eject_cassette
  end

  describe '#request_shipment' do
    before { VCR.insert_cassette 'shipment', record: :new_episodes }

    let(:shipment_request) { Dhl::ShipmentRequest.new }
    let(:shipper) { FactoryGirl.build(:contact) }
    let(:recipient) { FactoryGirl.build(:contact) }
    let(:packages) { shipment_request.packages }
    let(:shipment) { FactoryGirl.build(:shipment) }
    let(:response) { client.request_shipment(shipment_request) }

    it "should return a PDF shipping label" do
      shipment_request.shipper = shipper
      shipment_request.recipient = recipient
      shipment.pickup_time = (Time.now + 86400)
      shipment_request.shipment = shipment
      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      response[:tracking_number].should == '9085882330'
      File.exists?('labels/9085882330.pdf').should be_true
    end
  end

  describe '#track' do
    context 'the shipment has been fully delivered' do
      before { VCR.insert_cassette 'tracking/5223281416', record: :new_episodes}
      let(:response) { client.track "5223281416" }

      its(:shipment_info) { should_not be_nil }
      it { should have_at_least(1).event }
      it { should be_delivered }
    end

    context 'the shipment is not yet delivered' do
      before { VCR.insert_cassette 'tracking/6676848301', record: :new_episodes}
      let(:response) { client.track "6676848301" }
      it { should_not be_delivered }
    end

    # More VCR cassettes for testing purposes
    context 'the shipment has been fully delivered' do
      before { VCR.insert_cassette 'tracking/9786162326', record: :new_episodes}
      let(:response) { client.track "9786162326" }
      it { should be_delivered }
    end

    context 'the shipment has been fully delivered' do
      before { VCR.insert_cassette 'tracking/5223300596', record: :new_episodes}
      let(:response) { client.track "5223300596" }
      it { should be_delivered }
    end

    context 'the shipment has been fully delivered' do
      before { VCR.insert_cassette 'tracking/6676848415', record: :new_episodes}
      let(:response) { client.track "6676848415" }
      it { should be_delivered }
    end
  end

end
