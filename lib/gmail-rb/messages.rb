module Gmail

  class Messages < Client

    def list(opts = {})

      # Work out what to pass to the call
      conn_body = {}
      conn_body[:maxResults] = opts.fetch(:max_results) { '20' }
      conn_body[:labelIds] = opts.fetch(:labels) unless opts.fetch(:labels) { nil }.nil?

      puts conn_body

      # Make the call
      response = connection.get '/gmail/v1/users/me/messages', conn_body

      # 
      parsed = JSON.parse(response.body)

      load_children = opts.fetch(:load_children) { true }
      if (load_children)
        parsed['messages'].map do |m|
          get(m['id'])
        end
      else
        parsed['messages'].map { |m| Model::Message.new(m) }
      end
    end

    def get(id)
      response = connection.get "/gmail/v1/users/me/messages/#{id}", {
        "fields" => "subject"
      }

      puts response.body
      JSON.parse(response.body)
    end

  end

end