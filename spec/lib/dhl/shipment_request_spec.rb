require (File.expand_path('./../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Dhl::ShipmentRequest do
  let(:shipment_request) { Dhl::ShipmentRequest.new }
  let(:shipper) { FactoryGirl.build(:contact) }
  let(:recipient) { FactoryGirl.build(:contact) }
  let(:packages) { shipment_request.packages }
  let(:shipment) { FactoryGirl.build(:shipment) }

  describe '#to_hash' do
    it "should return the expected hash structure" do
      shipment_request.shipper = shipper
      shipment_request.recipient = recipient
      shipment_request.shipment = shipment

      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      hash = shipment_request.to_hash
      hash.should == {
          requested_shipment: {
          shipment_info: {
            drop_off_type: "REGULAR_PICKUP",
            service_type: 'N',
            currency: 'EUR',
            unit_of_measurement: 'SI', # Or SU, UK, US
            account: Dhl::Configuration.new.account
          },
          ship_timestamp: '2015-12-31T16:45:10GMT+00:00', # When is the shipment going to be ready for pickup?
          payment_info: 'DAP',
          international_detail: {
            commodities: {
              number_of_pieces: 2,
              description: 'General goods',
              country_of_manufacture: "IT"
            },
            content: "DOCUMENTS"
          },
          ship: {
            shipper: {
              contact: {
                person_name: 'John Doe',
                company_name: 'ACME Inc',
                phone_number: '+391234567890',
                email_address: 'john@example.com' # Optional
              },
              address: {
                street_lines: 'Piazza Duomo, 1234',
                street_lines_2: 'Scala B', # Optional
                city: 'Milano',
                postal_code: '20121',
                country_code: 'IT',
                street_name: 'Piazza Duomo', # Optional
                street_number: '1234', # Optional
                state_or_province_code: 'MI' # Optional
              }
            },
            recipient: {
              contact: {
                person_name: 'John Doe',
                company_name: 'ACME Inc',
                phone_number: '+391234567890',
                email_address: 'john@example.com' # Optional
              },
              address: {
                street_lines: 'Piazza Duomo, 1234',
                street_lines_2: 'Scala B', # Optional
                city: 'Milano',
                postal_code: '20121',
                country_code: 'IT',
                street_name: 'Piazza Duomo', # Optional
                street_number: '1234', # Optional
                state_or_province_code: 'MI' # Optional
              }
            }
          },
          packages: {
            requested_packages: [
              {
                weight: 50,
                dimensions: {
                  width: 10,
                  height: 15,
                  length: 20
                },
                customer_references: 'Ref 1'
              },
              {
                weight: 100,
                dimensions: {
                  width: 40,
                  height: 45,
                  length: 35
                },
                customer_references: 'Ref 2'
              }
            ],
            :attributes! => { requested_packages: { number: [1, 2] } }
          }
        }
      }
    end

  end

end
