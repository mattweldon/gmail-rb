module Gmail

  class Connection

    attr_accessor :url, :connection, :access_token, :refresh_token

    def initialize(connection_url, credentials = nil)
      @access_token = credentials.fetch(:access_token) { nil } unless credentials.nil?

      @connection = Faraday.new(:url => connection_url) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  Faraday.default_adapter
        builder.authorization(:Bearer, @access_token) unless @access_token.nil?
      end
    end

    def url_prefix
      prefix = @connection.url_prefix.to_s
      prefix = prefix[0..-1] if prefix.end_with?('/')
      prefix
    end

    def set_credentials!(credentials)
      @connection.authorization :Bearer => access_token
    end

    def get(url, body = nil)
      if body.nil?
        @connection.get(url)
      else
        @connection.get(url, body)
      end
    end

    def post(url, body = nil)
      if body.nil?
        @connection.post(url)
      else
        @connection.post(url, body)
      end
    end

  end

end