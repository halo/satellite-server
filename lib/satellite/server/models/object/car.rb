require 'satellite/server/models/object/object'
require 'satellite/extensions/core/numeric/radians'

module Satellite
  module Server
    module Models
      module Object
        class Car < Object

          attr_reader :shape
          attr_accessor :options

          def initialize(options={})
            super
            @shape = CP::Shape::Poly.new(self.body, surface, CP::Vec2.new(0,0))
            @shape.collision_type = :car
          end

          def export
            OpenStruct.new id: id, type: :car, x: @body.p.x.to_i, y: @body.p.y.to_i, z: 3, a: @body.a.round(2)
          end

          # Directly set the position of our Player
          def warp(vect)
            @body.p = vect
          end

          # Apply negative Torque; Chipmunk will do the rest
          # SUBSTEPS is used as a divisor to keep turning rate constant
          # even if the number of steps per update are adjusted
          def turn_left
            @body.t -= turning_speed
          end

          # Apply positive Torque; Chipmunk will do the rest
          # SUBSTEPS is used as a divisor to keep turning rate constant
          # even if the number of steps per update are adjusted
          def turn_right
            @body.t += turning_speed
          end

          def turning_speed
            (30.0 - turning_damper)
          end

          def turning_damper
            speed = @body.v.lengthsq
            return 0 if speed > 30
            30 - speed
          end

          # Apply forward force; Chipmunk will do the rest
          # SUBSTEPS is used as a divisor to keep acceleration rate constant
          # even if the number of steps per update are adjusted
          # Here we must convert the angle (facing) of the body into
          # forward momentum by creating a vector in the direction of the facing
          # and with a magnitude representing the force we want to apply
          def accelerate
            @body.apply_force((@body.a.radians_to_vec2 * (50.0)), CP::Vec2.new(0.0, 0.0))
          end

          # Apply reverse force
          # See accelerate for more details
          def reverse
            @body.apply_force(-(@body.a.radians_to_vec2 * (50.0)), CP::Vec2.new(0.0, 0.0))
          end

          private

          def surface
            [CP::Vec2.new(-25.0, -10.0), CP::Vec2.new(-25.0, 10.0), CP::Vec2.new(25.0, 10.0), CP::Vec2.new(25.0, -10.0)]
          end

        end
      end
    end
  end
end