require 'satellite/server/controllers/default'

module Satellite
  module Server
    module Controllers
      class Menu < Default

        def process_update
          broadcast_state
          super
        end

        # In the menus we need just a few updates per second (to save CPU power).
        def throttle
          5
        end

      end
    end
  end
end
