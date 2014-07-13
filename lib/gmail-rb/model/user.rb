module Gmail
  module Model

    class User
      attr_accessor :first_name, :last_name, :email, :uid

      def initialize(profile_node)
        @uid = profile_node.fetch('id') { "-1" }
        @first_name = profile_node.fetch('given_name') { '' }
        @last_name = profile_node.fetch('family_name') { '' }
        @email = profile_node.fetch('email') { '' }
      end
    end

  end
end