require 'chipmunk'
require 'satellite/server/controllers/shared/message_sender'

module Satellite
  module Server
    module Controllers
      module Managers
        class Space
          include Shared::MessageSender

          def initialize(options={})
            @space = CP::Space.new
            @space.damping = 0.8  # Every object looses 20% of force per step while it moves through the space
            @dt = (1.0 / 30.0)  # Time over which to apply a physics "step" ("delta t")
            @objects = {}
          end

          def on_message(message)
            messages_to_send.clear
            case message.kind
            when :player_left
              player = message.data
              @space.delete player.object
            when :new_player
              player = message.data
              player.object = Object::Car.new
              object.warp(CP::Vec2.new(100 + (@space.objects.size * 50), 200))
              @space << player.object
            when :update
              update
              send_fields
            end
            messages_to_send
          end

          def update
            # For accuracy, the physics update 5 times more often than the view.
            5.times do
              update!
            end
          end

          def update!
            Player.all do |player|
              object = player.object
              object.shape.body.reset_forces

              if player.holding? :left
                object.turn_left
              elsif player.holding? :right
                object.turn_right
              end

              unless player.holding?(:left) || player.holding?(:right)
                delta = 0.005
                if object.shape.body.w > 0
                  object.shape.body.w -= delta
                elsif object.shape.body.w < 0
                  object.shape.body.w += delta
                end
              end

              if player.holding? :up
                object.accelerate
              elsif player.holding? :down
                object.reverse
              end
            end
            @space.advance
          end

          def send_fields
            Player.all do |player|
              field = Field.new
              @space.objects.each do |object|
                field << object
              end
              field.camera = Camera.new(object: player.object)
              send_event player.id, :field, field.export
            end
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
end
