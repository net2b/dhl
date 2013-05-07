module Dhl
  class Client

    def initialize
      @soap_client = Savon.client(
        wsdl: "https://wsbuat.dhl.com:8300/amer/GEeuExpressRateBook?WSDL",
        wsse_auth: [Dhl.configuration.username, Dhl.configuration.password],
        wsse_timestamp: true,
        convert_request_keys_to: :camelcase
      )
    end

    def soap_client
      @soap_client
    end

    def request_shipment
      response = client.call(:create_shipment_request, message: { requested_shipment: nil } )
    end

    small_hash = {}

    hash = {
      requested_shipment: {

        shipment_info: {
          # REGULAR_PICKUP if regularly served, REQUEST_COURIER if a courier should specifically go
          drop_off_type: "REGULAR_PICKUP",
          service_type: '',
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: '', # Optional, the customer account
          billing: { # Optional
            shipper_account_number: '', # DHL Account Number
            shipping_payment_type: '', # S for ShipperAccountNumber, R for BillingAccountNumber, or T for BillingAccountNumber
            billing_account_number: '', # Optional, if PaymentType is R or T
          },
          special_services: {}, # Optional

          shipment_identification_number: nil, # Unused
          packages_count: nil, # Unused
          send_package: nil # Unused
        },
        ship_timestamp: Time.now.strftime('%Y-%m-%dT%H:%M:%SGMT%z'), # When is the shipment going to be ready for pickup?
        payment_info: nil,
        international_detail: {
          commodities: {
            number_of_pieces: 1,
            description: 'Goods',
            country_of_manufacture: 'IT', # Optional
            quantity: '1', # Optional
            unit_price: '100.00', # Optional
            customs_value: '100.00' # Optional
          }
          content: 'NON_DOCUMENTS', # Optional, NON_DOCUMENTS or DOCUMENTS
          export_reference: nil # Optional; e.g.: EEI/ITN reference information required for the US export
        },
        ship: {
          shipper: contact_structure,
          recipient: contact_structure,
          pickup: contact_structure # Optional
        },
        packages: {
          requested_packages: [
            1: {
              weight: '15.000',
              dimensions: {
                length: '3,0',
                width: '3,0',
                height: '3,0'
              }
              customer_references: 'ewqqwe',
              insured_value: '100,00' # Optional
            }
          ]
        }
      }
    }

    def contact_structure
      {
        contact: {
          person_name: 'Alessandro Mencarini'
          company_name: 'freego'
          phone_number: '+391234567890'
          email_address: 'a.mencarini@freegoweb.it' # Optional
        },
        address: {
          street_lines: 'Via dei Baruffi 52',
          city: 'Paesello',
          postal_code: '12345',
          country_code: 'IT',
          street_name: 'Via dei Baruffi', # Optional
          street_number: '52', # Optional
          street_lines_2: '', # Optional
          street_lines_3: '', # Optional
          state_or_province_code: 'Androcchialand' # Optional
        }
      }
    end

    # SOAP Client operations:
    # => [:get_rate_request, :create_shipment_request, :delete_shipment_request]

  end
end
