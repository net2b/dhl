module Dhl
  class Client

    def config
      Dhl.config
    end

    def initialize
      username = config.username
      password = config.password
      raise 'Provide username and password (e.g.: `export DHL_USERNAME=dhlusername`).' if !@username || @password

      account = config.account
      raise 'Provide a DHL account number (e.g.: `export DHL_ACCOUNT=123456789`).' if !@username || @password

      @soap_client = Savon.client(
        wsdl: "https://wsbuat.dhl.com:8300/amer/GEeuExpressRateBook?WSDL",
        wsse_auth: [username, password],
        wsse_timestamp: true,
        convert_request_keys_to: :camelcase
      )
    end

    def soap_client
      # SOAP Client operations:
      # => [:get_rate_request, :create_shipment_request, :delete_shipment_request]
      @soap_client
    end

    def request_shipment
      response = client.call(:create_shipment_request, message: { requested_shipment: nil } )
    end

    def request_rate
      response = client.call(:get_rate_request, message: request_rate_hash )
    end



  end
end
