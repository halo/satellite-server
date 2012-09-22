require 'satellite/server/controllers/default'
require 'satellite/server/controllers/combat'

module Satellite
  module Server
    module Controllers
      class Loading < Menu

        def update
          switch Combat.new
        end

      end
    end
  end
end