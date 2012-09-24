require 'ostruct'
require 'satellite/server/models/field'
require 'satellite/server/models/object/car'
require 'satellite/server/models/player'
require 'satellite/server/models/camera'
require 'satellite/server/controllers/default'
require 'satellite/server/controllers/managers/broker'
require 'satellite/server/controllers/managers/space'
require 'satellite/server/controllers/managers/presence'
require 'satellite/server/controllers/shared/message_sender'

module Satellite
  module Server
    module Controllers
      class Combat < Default
        include Models
        include Shared::MessageSender

        attr_reader :broker

        def initialize(options={})
          super
          @broker = Managers::Broker.new
          @broker.add_consumer Managers::Presence.new
          @broker.add_consumer Managers::Space.new
        end

        def on_event(event)
          send_message :network_event, event
        end

        def update
          send_message :update
          broker.dispatch
        end

      end
    end
  end
end