require "dhl/version"
require "dhl/client"
require "dhl/configuration"

module Dhl

  def self.setup
    yield self.configuration
  end

  def self.configuration
    @config ||= Configuration.new
  end

  def self.client
    @client ||= Client.new.soap_client
  end

end
