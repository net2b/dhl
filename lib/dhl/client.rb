module Dhl
  class Client

    def config
      Dhl.config
    end

    def client_options
      {
        wsse_auth: [config.username, config.password],
        wsse_timestamp: true,
        convert_request_keys_to: :camelcase
      }
    end

    def initialize(options)
      config.username ||= options[:username]
      raise 'Provide a username (e.g.: `export DHL_USERNAME=dhlusername`).' if !config.username

      config.password ||= options[:password]
      raise 'Provide a password (e.g.: `export DHL_PASSWORD=dhlpassword`).' if !config.password

      config.account ||= options[:account]
      raise 'Provide a DHL account number (e.g.: `export DHL_ACCOUNT=123456789`).' if !config.account

      @requests_soap_client = Savon.client(client_options.merge(wsdl: "https://wsbuat.dhl.com:8300/amer/GEeuExpressRateBook?WSDL"))
      @tracking_soap_client = Savon.client(client_options.merge(wsdl: "https://wsbuat.dhl.com:8300/gbl/glDHLExpressTrack?WSDL"))
    end

    def requests_soap_client
      # SOAP Client operations:
      # => [:get_rate_request, :create_shipment_request, :delete_shipment_request]
      @requests_soap_client
    end

    def tracking_soap_client
      # SOAP Client operations:
      # => [:track_shipment_request]
      @tracking_soap_client
    end


    def request_shipment(shipment_request)
      response = requests_soap_client.call(:create_shipment_request, message: shipment_request.to_hash )

      if response.body[:shipment_response][:notification][:@code] != '0'
        raise "Error: #{response.body[:shipment_response][:notification][:message]}"
      end

      result = {}

      image_format = response.body[:shipment_response][:label_image][:label_image_format]
      shipment_identification_number = response.body[:shipment_response][:shipment_identification_number]
      shipping_label_filename = "#{shipment_identification_number}.#{image_format.downcase}"
      Dir.mkdir('labels') unless File.exists?('labels')
      File.open("labels/#{shipping_label_filename}", 'wb') do |f|
        f.write( Base64.decode64( response.body[:shipment_response][:label_image][:graphic_image]) )
        result[:shipping_label] = File.absolute_path(f)
      end

      package_result = response.body[:shipment_response][:packages_result][:package_result]
      result[:tracking_numbers] = package_result.is_a?(Array) ? package_result.map{|r| r[:tracking_number]} : package_result[:tracking_number]

      result
    end

    def track(numbers)
      request = Dhl::TrackingRequest.new(numbers)
      response = tracking_soap_client.call(:track_shipment_request, message: request.to_hash)
      response.body
    end

    # def request_rate
    #   response = @soap_client.call(:get_rate_request, message: request_rate_hash )
    # end

  end
end
