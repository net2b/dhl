require "dhl/version"
require "dhl/client"
require "dhl/configuration"
require "dhl/contact"
require "dhl/packages"
require "dhl/package"
require "dhl/shipment"

module Dhl

  def self.setup
    yield self.configuration
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.client
    @client ||= Client.new.soap_client
  end

end

class Hash
  def remove_empty
    reject{ |key, value| value.nil? || value == '' }
  end
end
