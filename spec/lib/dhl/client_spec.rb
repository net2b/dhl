# require (File.expand_path('./../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
require_relative '../../spec_helper'

describe Dhl::Client do

  let(:client) { Dhl.client }

  describe '#request_shipment' do
    it "should return a PDF shipping label" do
      # shipper = Dhl::Contact.new
      # recipient = Dhl::Contact.new
      # packages = Dhl::Packages.new
      # shipment = Dhl::Shipment.new
      shipment_request = Dhl::ShipmentRequest.new
      shipment_request.shipper.update(name: 'Ciccio Pasticcio')
       = Dhl::Contact.new()



      (shipper, recipient, packages, shipment)
      response = client.request_shipment(shipper, recipient, packages, shipment)
    end
  end

end
