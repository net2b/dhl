module Dhl
  class Shipment
    attr_accessor :pickup_time, :pieces, :description, :domestic, :service_type, :payment_info, :special_service_type
    attr_accessor :shipment_identification_number
    attr_accessor :country_of_manufacture
    attr_accessor :quantity
    attr_accessor :unit_price
    attr_accessor :customs_value

    def to_hash
      hsh = {
        shipment_info: {
          drop_off_type: 'REGULAR_PICKUP',
          service_type: @service_type || 'N', # N: Domestic, U: EU, D: Extra-EU documents, P: Extra-EU parcels
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: Dhl.config.account,
          shipment_identification_number: @shipment_identification_number
        },
        ship_timestamp: @pickup_time.strftime('%Y-%m-%dT%H:%M:%SGMT%:z'), # When is the shipment going to be ready for pickup?
        payment_info: @payment_info || 'DAP',
        international_detail: {
          commodities: {
            number_of_pieces: @pieces,
            description: @description,
            customs_value: @customs_value,
            country_of_manufacture: @country_of_manufacture || 'IT',
            quantity: @quantity,
            unit_price: @unit_price
          },
          content: 'NON_DOCUMENTS'
        }
      }

      if @special_service_type
        hsh[:shipment_info].merge!(special_services: { service: { service_type: @special_service_type } })
      end

      hsh.remove_empty
    end
  end
end
