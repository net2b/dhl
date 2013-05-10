require 'savon'

require "dhl/client"
require "dhl/configuration"
require "dhl/contact"
require "dhl/packages"
require "dhl/package"
require "dhl/shipment"
require "dhl/shipment_request"
require "dhl/tracking/request"
require "dhl/tracking/response"
require "dhl/tracking/item"
require "dhl/tracking/event"

require "dhl/version"

module Dhl

  def self.setup
    yield self.config
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
