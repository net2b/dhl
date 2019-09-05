module Dhl
  class Shipment
    attr_accessor :pickup_time, :pieces, :description, :domestic, :service_type, :payment_info, :taxes_included, :insurance_value
    attr_accessor :shipment_identification_number
    attr_accessor :country_of_manufacture
    attr_accessor :quantity
    attr_accessor :unit_price
    attr_accessor :customs_value
    attr_accessor :international_detail_content
    attr_accessor :label_type
    attr_accessor :label_template

    def initialize
      @taxes_included = false
      @insurance_value = 0
    end

    def to_hash
      hsh = {
        shipment_info: {
          drop_off_type: 'REGULAR_PICKUP',
          service_type: @service_type || 'N', # N: Domestic, U: EU, D: Extra-EU documents, P: Extra-EU parcels
          currency: 'EUR',
          unit_of_measurement: 'SI', # Or SU, UK, US
          account: Dhl::Configuration.new.account,
          shipment_identification_number: @shipment_identification_number,
          label_options: { request_waybill_document: 'Y' }
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
          content: @international_detail_content || 'DOCUMENTS'
        }
      }

      special_services = []
      special_services << { service_type: 'DD' } if @taxes_included
      special_services << { service_type: 'II', service_value: @insurance_value, currency_code: 'EUR' } if @insurance_value.positive?
      hsh[:shipment_info].merge!(special_services: { service: special_services }) if special_services.present?

      if @label_template
        hsh[:shipment_info][:label_type] = @label_type || 'PDF'
        hsh[:shipment_info][:label_template] = @label_template
      end

      hsh.remove_empty
    end
  end
end
