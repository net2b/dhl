module Dhl
  class Package

    attr_accessor :weight, :width, :height, :length, :reference

    def initialize(weight, width, height, length, reference='')
      @weight, @width, @height, @length, @reference = weight, width, height, length, reference
    end

    def to_hash
      {
        weight: @weight,
        dimensions: {
          width: @width,
          height: @height,
          length: @length
        },
        customer_references: @reference
      }
    end

  end
end
