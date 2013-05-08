# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

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
      shipment_request.shipment = shipment

      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      response = client.request_shipment(shipment_request)
    end
  end

end
