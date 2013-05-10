module Dhl
  module Tracking
    class Response

      # attr_accessor :shipper, :recipient, :packages, :shipment

      def initialize(data)
        binding.pry
        items_data = data[:track_shipment_request_response][:tracking_response][:tracking_response][:awb_info]
        [items_data].flatten.each do |item_data|
          Item.new(item_data[:array_of_awb_info_item])
        end

      end

    end
  end
end
