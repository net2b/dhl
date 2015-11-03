module Dhl
  class Client
    attr_reader :config

    def client_options
      {
        wsse_auth: [@config.username, @config.password],
        wsse_timestamp: true,
        convert_request_keys_to: :camelcase,
        namespaces: {
          "xmlns:dhl" => "http://www.dhl.com"
        },
        ssl_verify_mode: :none, # Until we can figure what's wrong with SSL
        log_level: @config.log_level || :info,
        logger: @config.logger || Logger.new($stdout),
        log: true
      }
    end

    def initialize(options = {})
      @config = Dhl::Configuration.new(options)
    end

    def requests_soap_client
      # SOAP Client operations:
      # => [:get_rate_request, :create_shipment_request, :delete_shipment_request]
      return @requests_soap_client if @requests_soap_client

      if @config.environment == 'production'
        wsdl = "https://wsbexpress.dhl.com:443/gbl/expressRateBook?WSDL"
      else
        wsdl = "https://wsbexpress.dhl.com:443/sndpt/expressRateBook?WSDL"
      end

      @requests_soap_client = Savon.client(client_options.merge(wsdl: wsdl))
    end

    def tracking_soap_client
      # SOAP Client operations:
      # => [:track_shipment_request]
      return @tracking_soap_client if @tracking_soap_client

      if @config.environment == 'production'
        wsdl = "https://wsbexpress.dhl.com:443/gbl/glDHLExpressTrack?WSDL"
      else
        wsdl = "https://wsbexpress.dhl.com:443/sndpt/glDHLExpressTrack?WSDL"
      end

      @tracking_soap_client = Savon.client(client_options.merge(wsdl: wsdl))
    end

    def request_shipment(shipment_request)
      response = requests_soap_client.call(:create_shipment_request, message: shipment_request.to_hash )

      data = response.body[:shipment_response][:notification]
      notification = data.include?(:@code) ? data : data.first

      raise Dhl::Error::Generic.new(notification[:@code], notification[:message]) unless notification[:@code] == '0'

      result = {}

      image_format = response.body[:shipment_response][:label_image][:label_image_format]
      shipment_identification_number = response.body[:shipment_response][:shipment_identification_number]
      shipping_label_filename = "#{shipment_identification_number}.#{image_format.downcase}"
      labels_directory = @config.tmp_labels_dir
      Dir.mkdir(labels_directory) unless File.exists?(labels_directory)
      File.open("#{labels_directory}/#{shipping_label_filename}", 'wb') do |f|
        f.write( Base64.decode64( response.body[:shipment_response][:label_image][:graphic_image]) )
        result[:shipping_label] = File.absolute_path(f)
      end

      package_result = response.body[:shipment_response][:packages_result][:package_result]
      result[:tracking_number] = shipment_identification_number

      result
    end

    def track(number)
      request = Tracking::Request.new(number)
      response = tracking_soap_client.call(:track_shipment_request, message: request.to_hash)
      Tracking::Response.new(response.body)
    end

    # def request_rate
    #   response = @soap_client.call(:get_rate_request, message: request_rate_hash )
    # end
  end

end
