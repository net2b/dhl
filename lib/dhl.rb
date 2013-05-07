require "dhl/version"
require "dhl/client"
require "dhl/configuration"

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
