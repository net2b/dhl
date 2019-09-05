require 'base64'

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
          content: @international_detail_content || 'DOCUMENTS'
        }
      }

      special_services = []
      special_services << { service_type: 'WY' } if @paperless_document
      special_services << { service_type: 'DD' } if @taxes_included
      special_services << { service_type: 'II', service_value: @insurance_value, currency_code: 'EUR' } if @insurance_value.positive?
      hsh[:shipment_info].merge!(special_services: { service: special_services }) if special_services.present?

      if @label_template
        hsh[:shipment_info][:label_type] = @label_type || 'PDF'
        hsh[:shipment_info][:label_template] = @label_template
      end

      if @paperless_document
        encoded_paperless_document = Base64.encode64 @paperless_document
        hsh[:shipment_info].merge!(paperless_trade_enabled: true, paperless_trade_image: encoded_paperless_document)
      end

      hsh.remove_empty
    end
  end

  def paperless_available?(country_code, order_value)
    # currency: EUR
    max_order_value_by_country = Hash.new(Float::INFINITY).merge!(
      {
        'AE' => 12000, # 13623 USD
        'AF' => 0,
        'AM' => 0,
        'AZ' => 0,
        'BD' => 0,
        'BH' => 1100, # 1300 USD
        'BR' => 0,
        'BY' => 0,
        'CL' => 0,
        'CR' => 0,
        'DZ' => 0,
        'EG' => 0,
        'GE' => 0,
        'GT' => 0,
        'HN' => 0,
        'ID' => 0,
        'IN' => 0,
        'IQ' => 0,
        'IR' => 0,
        'JO' => 900, # 1000 JD
        'KG' => 0,
        'KW' => 0,
        'KZ' => 0,
        'LB' => 0,
        'LY' => 0,
        'MA' => 0,
        'MD' => 0,
        'NI' => 0,
        'OM' => 2300, # 2590 USD
        'PE' => 0,
        'PH' => 0,
        'PK' => 0,
        'QA' => 0,
        'RS' => 50,
        'RU' => 0,
        'SA' => 180, # 200 USD
        'SV' => 0,
        'SY' => 0,
        'TJ' => 0,
        'TN' => 0,
        'UA' => 0,
        'UZ' => 0,
        'VN' => 0,
        'YE' => 0,
       }
    )
    order_value <= max_order_value_by_country[country_code]
  end
end
