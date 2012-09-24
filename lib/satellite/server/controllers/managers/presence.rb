require 'satellite/log'
require 'satellite/server/controllers/shared/event_sender'
require 'satellite/server/controllers/shared/message_sender'

module Satellite
  module Server
    module Controllers
      module Managers
        class PresenceManager
          include Shared::EventSender
          include Shared::MessageSender

          def on_message(message)
            messages_to_send.clear
            return unless message.kind == :network_event
            player = Player.find(message.data.sender_id)

            case message.data.kind
            when :leave
              if player
                #broadcast :leave, player.export
                player.destroy
                send_message :player_left, player
              end
            when :presence
              unless player
                Player.create id: message.data.sender_id
                send_message :new_player, player
              end
            when :input
              player.input = message.data.data if player
            end

            messages_to_send
          end

        end
      end
    end
  end
end