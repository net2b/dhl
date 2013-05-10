module Dhl
  module Tracking
    class Request

      attr_accessor :tracking_number

      # Accepts and array of tracking numbers
      def initialize(numbers)
        @tracking_numbers = numbers
      end

      def to_hash
        {
          'trackingRequest' => {
            'dhl:TrackingRequest' => {
              request: {
                service_header: {
                  message_time: Time.now.strftime('%Y-%m-%dT%H:%M:%S%:z'),
                  message_reference: '1234567890123456789012345678' # Ref between 28 and 32 characters
                }
              },
              a_w_b_number: {
                array_of_a_w_b_number_item: @tracking_numbers
              },
              # lp_number: nil, # Inactive in API
              level_of_details: 'ALL_CHECK_POINTS', # LAST_CHECK_POINT_ONLY for partial tracking
              pieces_enabled: 'B' # B for Both, S for shipment details only, P for piece details only
            }
          }
        }
      end

    end
  end
end
