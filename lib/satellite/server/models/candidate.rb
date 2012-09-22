require 'satellite/db/model'

module Satellite
  module Server
    module Models
      class Candidate < DB::Model
        attr_accessor :ready, :gamertag

        def initialize(options={})
          super
          @gamertag = options[:gamertag]
          @ready = false
        end

      end
    end
  end
end