module Dhl
  class Shipment

    attr_accessor :pickup_time, :pieces, :description, :domestic, :customs_value, :service_type, :payment_info

    def to_hash
      {
        shipment_info: {
          drop_off_type: "REGULAR_PICKUP",
          service_type: @service_type || 'N', # N: Domestic, U: EU, D: Extra-EU documents, P: Extra-EU parcels
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: Dhl.config.account
        },
        ship_timestamp: @pickup_time.strftime('%Y-%m-%dT%H:%M:%SGMT%:z'), # When is the shipment going to be ready for pickup?
        payment_info: @payment_info || 'DDP',
        international_detail: {
          commodities: {
            number_of_pieces: @pieces,
            description: @description,
            customs_value: @customs_value
          }
        }
      }.remove_empty
    end


  end
end
