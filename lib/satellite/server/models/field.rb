require 'ostruct'

module Satellite
  module Server
    module Models
      class Field
        attr_accessor :camera

        def initialize(options={})
          @objects = {}
        end

        def << (object)
          @objects[object.id] = object.export
        end

        def camera=(new_camera)
          @camera = OpenStruct.new x: new_camera.x, y: new_camera.y
        end

        def export
          entities = @objects.values.map do |object|
            if camera
              object.x -= camera.x
              object.y -= camera.y
            end
            OpenStruct.new id: object.id, x: object.x, y: object.y, z: object.z, a: object.a, image_name: (object.type.to_s + '.png')
          end
          entities << OpenStruct.new(id: 'background', image_name: 'map.jpg', x: -camera.x, y: -camera.y, a: 0, z:0)
          OpenStruct.new entities: entities
        end

        #def setup
        #  background = Object::Background.new(path: "assets/map.jpg")
        #  @field << background
        #end

      end
    end
  end
end
