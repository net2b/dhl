module Dhl
  class Packages

    attr_accessor :packs

    def initialize
      @packs = []
    end

    def add(weight, width, height, length, reference='')
      @packs << Dhl::Package.new(weight, width, height, length, reference)
    end

    def packs_hash
      @packs.map(&:to_hash)
    end

    def to_hash
      {
        requested_packages: packs_hash,
        :attributes! => { requested_packages: { number: (1..@packs.size).to_a } }
      }
    end

  end
end
