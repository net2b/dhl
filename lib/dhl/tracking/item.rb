module Dhl
  module Tracking
    class Item

      attr_accessor :events

      def initialize(data)
        binding.pry
        events_data = data[:pieces][:piece_info][:array_of_piece_info_item][:piece_event][:array_of_piece_event_item]
        @events = [events_data].flatten.map{ |event_data| Event.new(event_data) }
      end

    end
  end
end
