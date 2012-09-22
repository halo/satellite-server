require 'ostruct'
require 'satellite/extensions/core/object/random'
require 'satellite/server/models/object/physics/body'
require 'satellite/server/models/object/physics/radian'
require 'satellite/db/model'

module Satellite
  module Server
    module Models
      module Object
        class Object < Satellite::DB::Model

          attr_reader :id, :body
          attr_accessor :options

          def initialize(options={})
            @id = options[:id] || random_id
            @options = OpenStruct.new(options)
            setup_body
          end

          private

          def setup_body
            @body = Physics::Body.new(mass: mass, inertia: inertia)
            @body.p = CP::Vec2.new(0.0, 0.0)  # position
            @body.v = CP::Vec2.new(0.0, 0.0)  # velocity
            @body.a = Physics::Radian::top
          end

          # Internal: The default mass of this object
          def mass
            10
          end

          # Internal: The default rotational mass of this object
          def inertia
            150
          end

        end
      end
    end
  end
end