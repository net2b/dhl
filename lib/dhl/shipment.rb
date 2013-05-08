module Dhl
  class Shipment

    attr_accessor :pickup_time, :pieces, :description

    def to_hash
      {
        shipment_info: {
          drop_off_type: "REGULAR_PICKUP",
          service_type: 'N',
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: Dhl.config.account
        },
        ship_timestamp: @pickup_time.strftime('%Y-%m-%dT%H:%M:%SGMT%:z'), # When is the shipment going to be ready for pickup?
        payment_info: 'DDP',
        international_detail: {
          commodities: {
            number_of_pieces: 2,
            description: 'General goods'
          }
        }
      }
    end


  end
end
