module Dhl
  class Configuration

    attr_accessor :username, :password, :account
    def initialize
      @username = ENV['DHL_USERNAME']
      @password = ENV['DHL_PASSWORD']
      @account = ENV['DHL_ACCOUNT']
    end

  end
end
