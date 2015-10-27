require (File.expand_path('./../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Dhl::Shipment do

  let(:shipment) { Dhl::Shipment.new }

  describe '#to_hash' do
    stub_dhl_env_variables!

    it "should return the expected hash structure" do
      shipment.pickup_time = Time.parse("31/12/2013 16:45:10 GMT")
      shipment.pieces = 2
      shipment.description = 'General goods'
      shipment.domestic = true

      hash = shipment.to_hash
      hash.should == {
        shipment_info: {
          drop_off_type: "REGULAR_PICKUP",
          service_type: 'N',
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: 123456789
        },
        ship_timestamp: '2013-12-31T17:45:10GMT+01:00', # When is the shipment going to be ready for pickup?
        payment_info: 'DAP',
        international_detail: {
          commodities: {
            number_of_pieces: 2,
            description: 'General goods',
            country_of_manufacture: "IT"
          },
          content: "NON_DOCUMENTS"
        }
      }
    end

    # it "should raise an exception if not all required fields are present"
  end

end
