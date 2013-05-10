module Dhl
  module Tracking
    class Event

      attr_accessor :datetime, :signatory, :code, :description, :shipper_reference, :area_code, :area_name

      def initialize(data)
        @datetime = Time.parse("#{data[:date].to_s} #{data[:time].to_s}")
        @signatory = data[:signatory]
        @code = data[:service_event][:event_code]
        @description = data[:service_event][:description]
        @shipper_reference = data[:shipper_reference]
        @area_code = data[:service_area][:service_area_code]
        @area_name = data[:service_area][:description]
      end

    end
  end
end
