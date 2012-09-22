require 'satellite/server/controllers/candidate_meeting'
require 'satellite/server/controllers/briefing'
require 'satellite/server/models/candidate'

module Satellite
  module Server
    module Controllers
      class Lobby < CandidateMeeting

        def on_event(event)
          case event.kind
          when :new_game
            switch Briefing.new creator_id: event.sender_id
          end
        end

        def update
          broadcast :candidates, Candidate.export(:gamertag) if Candidate.any?
        end

      end
    end
  end
end