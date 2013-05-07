    request_rate_small_hash = {
      requested_shipment: {
        drop_off_type: "REGULAR_PICKUP",
        ship: {
          shipper: address_structure,
          recipient: address_structure
        },
        packages: {
          requested_packages: [
            {
              weight: {
                value: '15'
              },
              dimensions: {
                length: '3',
                width: '3',
                height: '3'
              }
            }
          ]
        },
        ship_timestamp: Time.now.strftime('%Y-%m-%dT%H:%M:%SGMT+01:00'), # When is the shipment going to be ready for pickup?
        account: ENV['DHL_CUSTOMER_CODE'],
        unit_of_measurement: 'SI' # Or SU, UK, US,
      }
    }
    response = client.call(:get_rate_request, message: request_rate_small_hash )

    request_rate_hash = {
      requested_shipment: {
        drop_off_type: "REGULAR_PICKUP",
        next_business_day: nil, # Optional, Y or N
        ship: {
          shipper: address_structure,
          recipient: address_structure
        },
        packages: {
          requested_packages: [
            1 => {
              weight: '15',
              dimensions: {
                length: '3,0',
                width: '3,0',
                height: '3,0'
              }
            }
          ]
        },
        ship_timestamp: Time.now.strftime('%Y-%m-%dT%H:%M:%SGMT%z'), # When is the shipment going to be ready for pickup?
        unit_of_measurement: 'SI', # Or SU, UK, US
        content: '', # Optional
        payment_info: '', # Optional
        account: '', # Optional
        billing: {}, # Optional
        special_services: {} # Optional
      }
    }


    # request_shipment examples
    request_shipment_small_hash = {
      requested_shipment: {
        shipment_info: {
          drop_off_type: "REGULAR_PICKUP",
          service_type: 'U',
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: ENV['DHL_CUSTOMER_CODE'],

        },
        ship_timestamp: Time.now.+(5.days).strftime('%Y-%m-%dT19:%M:%SGMT+01:00'), # When is the shipment going to be ready for pickup?
        payment_info: 'DDP',
        international_detail: {
          commodities: {
            number_of_pieces: 1,
            description: 'Goods',
          }
        },
        ship: {
          shipper: contact_structure,
          recipient: recipient_contact_structure,
        },
        packages: [
          requested_packages: {
            weight: '15',
            dimensions: {
              length: '3',
              width: '3',
              height: '3'
            },
            customer_references: 'ewqqwe'
          },
          :attributes! => { requested_packages: { number: 1 } }
        ]
      }
    }
    response = client.call(:create_shipment_request, message: request_shipment_small_hash )

    request_shipment_hash = {
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
          },
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
            {
              weight: '15.000',
              dimensions: {
                length: '3,0',
                width: '3,0',
                height: '3,0'
              },
              customer_references: 'ewqqwe',
              insured_value: '100,00' # Optional
            }
          ]
        }
      }
    }



    def address_structure
      {
        street_lines: 'Loc Bellocchi 68B',
        city: 'Fano',
        postal_code: '61032',
        country_code: 'IT',
        street_name: 'Loc Bellocchi', # Optional
        street_number: '68B', # Optional
        # street_lines_2: '', # Optional
        # street_lines_3: '', # Optional
        state_or_province_code: 'PU' # Optional
      }
    end

    def recipient_address_structure
      {
        street_lines: 'via Stephenson 48',
        city: 'Milano',
        postal_code: '20028',
        country_code: 'IT',
        street_name: 'via Stephenson', # Optional
        street_number: '48', # Optional
        # street_lines_2: '', # Optional
        # street_lines_3: '', # Optional
        state_or_province_code: 'MI' # Optional
      }
    end


    def contact_structure
      {
        contact: {
          person_name: 'Alessandro Mencarini',
          company_name: 'freego',
          phone_number: '+391234567890',
          email_address: 'a.mencarini@freegoweb.it' # Optional
        },
        address: address_structure
      }
    end
    def recipient_contact_structure
      {
        contact: {
          person_name: 'Maurizio de Magnis',
          company_name: 'Momit',
          phone_number: '+390987654321',
          email_address: 'maurizio.demagnis@momit.it' # Optional
        },
        address: recipient_address_structure
      }
    end
