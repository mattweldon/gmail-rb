module Gmail
  module Model

    class Label
      attr_accessor :id, :message_visibility, :label_visibility, :name, :type

      def initialize(label_node)
        @id = label_node.fetch('id') { raise "Invalid Label JSON node given" }
        @name = label_node.fetch('name') { raise "Invalid Label JSON node given" }
        @type = label_node.fetch('type') { raise "Invalid Label JSON node given" }

        @message_visibility = label_node.fetch('messageListVisibility') { '' } 
        @label_visibility = label_node.fetch('labelListVisibility') { '' } 
      end
    end

  end
end