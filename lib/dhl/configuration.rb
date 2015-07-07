module Dhl
  class Configuration
    attr_accessor :username, :password, :account, :environment, :log_level, :logger

    def initialize(options)
      @username    = options[:dhl_username]
      @password    = options[:dhl_password]
      @account     = options[:dhl_account]
      @environment = options[:dhl_environment] || :test
      @log_level   = options[:dhl_log_level] || :info
    end
  end
end
