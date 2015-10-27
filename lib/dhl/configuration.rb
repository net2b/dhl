module Dhl
  class Configuration
    attr_accessor :username, :password, :account, :environment, :log_level, :logger

    def initialize(options = {})
      options.merge!(fetch_dhl_options)

      fail 'Provide a username.'           unless options[:username]
      fail 'Provide a password.'           unless options[:password]
      fail 'Provide a DHL account number.' unless options[:account]

      @username    = options[:username]
      @password    = options[:password]
      @account     = options[:account]
      @environment = options[:environment] || :test
      @log_level   = options[:log_level] || :info
    end

    private

    def fetch_dhl_options
      {
        username: ENV['DHL_USERNAME'],
        password: ENV['DHL_PASSWORD'],
        account: ENV['DHL_ACCOUNT'],
        environment: ENV['DHL_ENVIRONMENT'] || :test,
        log_level: ENV['DHL_LOG_LEVEL'] || :info,
      }
    end
  end
end
