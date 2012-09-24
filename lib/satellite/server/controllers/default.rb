require 'satellite/log'
require 'satellite/extensions/core/string/inflections'
require 'satellite/extensions/core/object/underscored_class_name'
require 'satellite/extensions/core/time/milliseconds'
require 'satellite/server/controllers/shared/event_sender'

module Satellite
  module Server
    module Controllers
      class Default
        include Shared::EventSender

        attr_reader :replace
        # Public: Step 1 of 2 of the life-cycle. It gathers all messages from all clients.
        #         This method is called once per network event.
        #
        def process_event(event)
          on_event(event)
        end

        # Internal: Step 2 of 2 of the life-cycle. It updates the universe.
        #           This method is called once per game loop tick.
        #
        #def process_update
        #  update
        #end

        # Internal: Step 2 of 3 of the Controller life-cycle.
        #           It updates the universe.
        #
        def process_update
          @last_throttled_update ||= 0
          update
          if @last_throttled_update + 500 < Time.now.to_ms
            @last_throttled_update = Time.now.to_ms
            broadcast :state, state
            throttled_update
          end
        end

        # Internal: Define roughly how many updates per second should take place.
        #           Return nil for maximum.
        #
        # Returns: Integer or nil.
        def throttle
        end

        private

        # Internal: Convenience callback of process_event for subclasses.
        #
        def on_event(event)
        end

        # Internal: Convenience callback of process_update for subclasses.
        #
        def update
        end

        # Internal: Convenience callback update that is only evoked seldom enough for sending frequent network events.
        #
        def throttled_update
        end

        # Internal: Inform all clients of the current controller.
        #
        def broadcast_state
          broadcast :state, state
        end

        # Internal: The name of this controller state.
        def state
          underscored_class_name
        end

        # Internal: This controller dies now, mark for switching to another Controller.
        #
        def switch(controller)
          @replace = controller
        end

      end
    end
  end
end