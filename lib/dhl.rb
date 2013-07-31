require 'savon'

require "dhl/client"
require "dhl/configuration"
require "dhl/contact"
require "dhl/packages"
require "dhl/package"
require "dhl/shipment"
require "dhl/shipment_request"
require "dhl/tracking"
require "dhl/error"

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
  def deep_reject(&blk)
    self.dup.deep_reject!(&blk)
  end

  def deep_reject!(&blk)
    self.each do |k, v|
      v.deep_reject!(&blk)  if v.is_a?(Hash)
      self.delete(k)  if blk.call(k, v)
    end
  end

  def remove_empty
    deep_reject do |key, value|
      value.nil? || value == ''
    end
  end
end
