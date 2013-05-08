module Dhl
  class Client

    def config
      Dhl.config
    end

    def initialize(options)
      config.username ||= options[:username]
      config.password ||= options[:password]
      raise 'Provide username and password (e.g.: `export DHL_USERNAME=dhlusername`).' if !config.username || !config.password

      config.account ||= options[:account]
      raise 'Provide a DHL account number (e.g.: `export DHL_ACCOUNT=123456789`).' if !config.account

      @soap_client = Savon.client(
        wsdl: "https://wsbuat.dhl.com:8300/amer/GEeuExpressRateBook?WSDL",
        wsse_auth: [config.username, config.password],
        wsse_timestamp: true,
        convert_request_keys_to: :camelcase
      )
    end

    def soap_client
      # SOAP Client operations:
      # => [:get_rate_request, :create_shipment_request, :delete_shipment_request]
      @soap_client
    end

    def request_shipment(shipment_request)
      response = @soap_client.call(:create_shipment_request, message: shipment_request.to_hash )
    end

    # def request_rate
    #   response = @soap_client.call(:get_rate_request, message: request_rate_hash )
    # end

  end
end
