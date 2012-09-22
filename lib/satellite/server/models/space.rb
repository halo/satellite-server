require 'rubygems'
require 'chipmunk'

module Satellite
  module Server
    module Models
      class Space

        def initialize(options={})
          @space = CP::Space.new
          @space.damping = 0.8  # Every object looses 20% of force per step while it moves through the space
          @dt = (1.0 / 30.0)  # Time over which to apply a physics "step" ("delta t")
          @objects = {}
        end

        def objects
          @objects.values
        end

        def advance
          @space.step(@dt)
        end

        def <<(object)
          @space.add_body object.body
          @space.add_shape object.shape
          @objects[object.id] = object
        end

        def delete(object)
          @space.remove_body(object.body)
          @space.remove_shape(object.shape)
        end

      end
    end
  end
end
