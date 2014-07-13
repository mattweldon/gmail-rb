module Gmail

  class User < Client

    def profile
      response = connection.get "/userinfo/v2/me"
      Model::User.new(JSON.parse(response.body))
    end

  end

end