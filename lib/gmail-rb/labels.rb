module Gmail

  class Labels < Client

    def list
      response = connection.get '/gmail/v1/users/me/labels'
      parsed = JSON.parse(response.body)
      parsed['labels'].map { |m| Model::Label.new(m) }
    end

    def get(id)
      response = connection.get "/gmail/v1/users/me/labels/#{id}"
      Model::Label.new(JSON.parse(response.body))
    end

  end

end