require 'satellite/server/controllers/default'
require 'satellite/server/controllers/combat'

module Satellite
  module Server
    module Controllers
      # In the future we will transfer maps to the clients here and synchronize the beginning of the game
      class Loading < Menu

        def update
          switch Combat.new
        end

      end
    end
  end
end