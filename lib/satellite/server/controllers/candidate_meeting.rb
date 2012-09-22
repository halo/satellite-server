require 'satellite/log'
require 'satellite/server/controllers/menu'
require 'satellite/server/models/candidate'

module Satellite
  module Server
    module Controllers
      class CandidateMeeting < Menu
        include Models

        def process_event(event)
          if event.data && event.data.state == state
            case event.kind
            when :presence
              Candidate.create_or_update id: event.sender_id, gamertag: event.data.gamertag
            when :leave
              Candidate.destroy event.sender_id
            end
          end
          super
        end

      end
    end
  end
end