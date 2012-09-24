module Satellite
  module Server
    module Controllers
      module Managers
        class PresenceManager

          def on_event(event)
            player = Player.find(event.sender_id)
            
          end

        end
      end
    end
  end
end