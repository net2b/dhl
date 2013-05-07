module Dhl
  class Configuration

    attr_accessor :username, :password
    def initialize
      @username = ENV['DHL_USERNAME']
      @password = ENV['DHL_PASSWORD']
    end

  end
end
