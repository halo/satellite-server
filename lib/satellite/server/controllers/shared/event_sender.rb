require 'gamesocket/event'

module Satellite
  module Server
    module Shared
      module EventSender
        attr_reader :events_to_send

        def initialize(options={})
          @events_to_send = []
        end

        private

        # Internal: Enqueues a network event to be sent to all clients.
        #
        def broadcast(kind, data=nil)
          events_to_send << GameSocket::Event.new(kind: kind, data: data)
        end

        # Internal: Enqueues a network event to be sent to one client.
        #
        def send_event(receiver_id, kind, data=nil)
          events_to_send << GameSocket::Event.new(receiver_id: receiver_id, kind: kind, data: data)
        end

      end
    end
  end
end
