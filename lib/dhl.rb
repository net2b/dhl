require 'savon'

require 'dhl/client'
require 'dhl/configuration'
require 'dhl/contact'
require 'dhl/packages'
require 'dhl/package'
require 'dhl/shipment'
require 'dhl/shipment_request'
require 'dhl/tracking'
require 'dhl/error'

require 'dhl/version'

class Hash
  def deep_reject(&blk)
    dup.deep_reject!(&blk)
  end

  def deep_reject!(&blk)
    each do |k, v|
      v.deep_reject!(&blk) if v.is_a?(Hash)
      delete(k) if blk.call(k, v)
    end
  end

  def remove_empty
    deep_reject do |_key, value|
      value.nil? || value == ''
    end
  end
end
