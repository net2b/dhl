module Dhl
  module Tracking
    class Response

      # attr_accessor :shipper, :recipient, :packages, :shipment
      # attr_accessor :pieces
      attr_accessor :shipment_info, :events

      def initialize(data)
        @data = data
        @shipment_info = ShipmentInfo.new(@data)
        @events = get_events
      end

      def delivered?
        @events.first.delivered?
      end

      protected
        def get_events
          collection = @data[:track_shipment_request_response][:tracking_response][:tracking_response][:awb_info][:array_of_awb_info_item][:pieces][:piece_info][:array_of_piece_info_item][:piece_event][:array_of_piece_event_item]
          [collection].flatten.map do |element|
            Event.new(element)
          end
        rescue
          []
        end
    end
  end
end
