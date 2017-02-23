module Dhl
  class ShipmentRequest
    attr_accessor :shipper, :recipient, :packages, :shipment

    def initialize
      @shipper   = Dhl::Contact.new
      @recipient = Dhl::Contact.new
      @packages  = Dhl::Packages.new
      @shipment  = Dhl::Shipment.new
    end

    def to_hash
      {
        requested_shipment: @shipment.to_hash.merge(ship: {
                                                      shipper: @shipper.to_hash,
                                                      recipient: @recipient.to_hash
                                                    },
                                                    packages: @packages.to_hash)
      }
    end
  end
end
