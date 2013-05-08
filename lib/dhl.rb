require "dhl/version"
require 'savon'
require "dhl/client"
require "dhl/configuration"
require "dhl/contact"
require "dhl/packages"
require "dhl/package"
require "dhl/shipment"
require "dhl/shipment_request"

module Dhl

  def self.setup
    yield self.configuration
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.client(options={})
    @client ||= Client.new(options)
  end

end

class Hash
  def remove_empty
    reject{ |key, value| value.nil? || value == '' }
  end
end
