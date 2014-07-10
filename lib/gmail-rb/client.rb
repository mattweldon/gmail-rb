module Gmail

  class Client

    attr_accessor :options

    def initialize(options = {})
      @options = options
    end

    def connection
      @connection ||= Gmail::Connection.new(ENV['GMAIL_CLIENT_API_URL'], @options)
    end

  end

end