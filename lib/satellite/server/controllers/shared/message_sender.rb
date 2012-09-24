require 'satellite/server/controllers/managers/broker'

module Satellite
  module Server
    module Shared
      module MessageSender
        attr_reader :messages_to_send

        def initialize(options={})
          @messages_to_send = []
        end

        private

        def send_message(kind, data)
          messages_to_send << Managers::Broker::Message.new(kind: kind, data: data)
        end

      end
    end
  end
end