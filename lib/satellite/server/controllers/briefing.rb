require 'satellite/log'
require 'satellite/server/controllers/candidate_meeting'
require 'satellite/server/controllers/loading'

module Satellite
  module Server
    module Controllers
      class Briefing < CandidateMeeting
        attr_reader :creator_id

        def initialize(options={})
          super
          @creator_id = options[:creator_id]
        end

        def on_event(event)
          return unless candidate = Candidate.find(event.sender_id)
          case event.kind
          when :ready
            candidate.update_attribute(:ready, true) unless candidate.ready
          when :unready
            candidate.update_attribute(:ready, false) if candidate.ready
          when :start_game
            if all_ready? && candidate.id == creator_id
              switch Loading.new
            end
          end
        end

        def update
          set_creator_ready
          super
          Candidate.each do |candidate|
            send_event candidate.id, :candidates, candidates_export_for_receiver(candidate)
          end
        end

        def candidates_export_for_receiver(receiver)
          Candidate.map do |candidate|
            created_game = creator_id == candidate.id
            export = candidate.export :gamertag, :ready
            export['you'] = receiver.id == candidate.id
            export['created_game'] = created_game
            export['can_start_game'] = all_ready? && created_game
            export['can_be_ready'] = !created_game
            export
          end
        end

        def set_creator_ready
          creator = Candidate.find(creator_id)
          creator.update_attribute(:ready, true) if creator
        end

        def all_ready?
          Candidate.all?(&:ready)
        end

      end
    end
  end
end