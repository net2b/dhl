module Dhl
  class Configuration
    attr_accessor :username, :password, :account, :environment, :log_level, :logger, :log

    def initialize
      @username = ENV['DHL_USERNAME']
      @password = ENV['DHL_PASSWORD']
      @account = ENV['DHL_ACCOUNT']
      @environment = ENV['DHL_ENVIRONMENT'] || :test
      @log_level = ENV['DHL_LOG_LEVEL'] || :info
      @log = ENV['DHL_LOG']
    end
  end
end
