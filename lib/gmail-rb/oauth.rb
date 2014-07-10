module Gmail

  # Handles all OAuth toekn management required to access the GMail API.
  #
  class OAuth

    attr_accessor :client_id, :client_secret
    attr_accessor :auth_token # token received after initial auth required to get refresh token
    attr_accessor :access_token # short-lived token providing access to api calls
    attr_accessor :refresh_token # long-lived token which is used to provide new access_tokens


    def initialize(opts = {})
      # We need these
      @client_id = opts.fetch(:client_id) { raise "option client_id must be passed" }
      @client_secret = opts.fetch(:client_secret) { raise "option client_secret must be passed" }
      
      # But these are optional at this point
      set_tokens!(opts)
    end

    def connection
      @connection ||= Connection.new(ENV['GMAIL_AUTH_API_URL'], tokens)
    end

    # Sets tokens for access to the api
    # {
    #   :access_token => '',
    #   :refresh_token => ''
    # }
    #
    def set_tokens!(token_hash)
      @auth_token = token_hash.fetch(:auth_token) { '' }
      @access_token = token_hash.fetch(:access_token) { '' }
      @refresh_token = token_hash.fetch(:refresh_token) { '' }
    end

    def tokens
      {
        :access_token => @access_token,
        :refresh_token => @refresh_token
      }
    end

    # Obtains the URL required to allow a user to authorize access to their account.
    #
    def authorization_url
      endpoint = "#{connection.url_prefix}/o/oauth2/auth"

      scopes = "https://www.googleapis.com/auth/gmail.readonly "
      scopes << "https://www.googleapis.com/auth/userinfo.profile "
      scopes << "https://www.googleapis.com/auth/userinfo.email"

      response_type = "code"
      access_type = "offline"
      approval_prompt = "force"

      redirect_uri = ENV['GMAIL_AUTHORIZATION_CALLBACK']

      "#{endpoint}?scope=#{scopes}&response_type=#{response_type}&access_type=#{access_type}&redirect_uri=#{redirect_uri}&approval_prompt=#{approval_prompt}&client_id=#{client_id}"
    end

    # Acquires the following key peices of data using the short-lived auth code
    # returned from the authorization process:
    #
    #   refresh_token - 
    #   access_token  - 
    #   expires       - 
    #   first_name    - 
    #   last_name     - 
    #   email         - 
    #
    def token_acquisition(auth_code)
      response = connection.post '/o/oauth2/token', {
        'code' => auth_code,
        'client_id' => @client_id,
        'client_secret' => @client_secret,
        'redirect_uri' => ENV['GMAIL_AUTHORIZATION_CALLBACK'],
        'scope' => '',
        'grant_type' => 'authorization_code'
      }

      token_hash = JSON.parse(response.body)

      {
        :access_token => token_hash.fetch("access_token"),
        :refresh_token => token_hash.fetch("refresh_token")
      }
    end

  end

end