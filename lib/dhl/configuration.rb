module Dhl
  class Configuration

    attr_accessor :username, :password, :account, :environment, :log_level, :logger
    def initialize
      @username = ENV['DHL_USERNAME']
      @password = ENV['DHL_PASSWORD']
      @account = ENV['DHL_ACCOUNT']
      @environment = ENV['DHL_ENVIRONMENT'] || :test
    end

  end
end
