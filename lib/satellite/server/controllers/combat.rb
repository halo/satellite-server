require 'ostruct'
require 'satellite/server/models/field'
require 'satellite/server/models/object/car'
require 'satellite/server/models/player'
require 'satellite/server/models/camera'
require 'satellite/server/controllers/default'
require 'satellite/server/controllers/managers/broker'
require 'satellite/server/controllers/managers/space'
require 'satellite/server/controllers/managers/presence'

module Satellite
  module Server
    module Controllers
      class Combat < Default
        include Models

        attr_reader :broker

        def initialize(options={})
          super
          @broker = Managers::Broker.new
          @broker.add_consumer Managers::Presence.new
          @broker.add_consumer Managers::Space.new
        end

        def on_event(event)
          send_message :network_event, event

          player = Player.find(event.sender_id)
          case event.kind
          when :leave
            if player
              @space.delete player.object
              player.destroy
              broadcast :leave, player.export
            end
          when :presence
            if player
              #Log.info "Player #{event.sender_id} re-joined the game."
            else
              object = Object::Car.new
              object.warp(CP::Vec2.new(100 + (@space.objects.size * 50), 200))
              @space << object
              Log.info "Adding Player #{event.sender_id} with object #{object.id}..."
              Player.create id: event.sender_id, object: object
            end
          when :input
            player.input = event.data
          else
            #Log.debug "Unknown event #{event.kind.inspect} by #{event.sender_id} with data #{event.data.inspect}"
          end
        end

        def update
          broker.dispatch
          update_space
          enqueue_fields
        end

        def update_space
          # For accuracy, the physics update 5 times more often than the view.
          5.times do
            update_space!
          end
        end

        def update_space!
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

        def enqueue_fields
          Player.all do |player|
            field = Field.new
            @space.objects.each do |object|
              field << object
            end
            field.camera = Camera.new(object: player.object)
            send_event player.id, :field, field.export
          end
        end

        def send_message(kind, data)
          Managers::Broker::Message.new(kind: kind, data: data)
        end

      end
    end
  end
end