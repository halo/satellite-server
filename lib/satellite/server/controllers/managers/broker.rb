require 'satellite/log'

module Satellite
  module Server
    module Controllers
      module Managers
        class Broker

          # Internal: Message queue container.
          attr_reader :queue

          # Internal: Instances of the consumers.
          attr_reader :consumers

          class Message
            def initialize(options={})
              @kind = options[:kind]
              @data = options[:data]
            end
          end

          def initialize
            reset!
          end

          def add_consumer(consumer)
            @consumers << consumer
          end

          def <<(message)
            return unless message.is_a?(Message)
            queue << message
          end

          # Public: Dispatch every message currently on queue to all registerd consumers.
          #
          def dispatch
            queue << nil
            while message = queue.shift
              consumers.each do |consumer|
                if response = consumer.on_message(message)
                  @queue += Array(response)
                end
              end
            end
          end

          # Internal: Rrset consumers and message queue. Useful for testing<tt>.</tt>
          def reset!
            @queue = []
            @consumers = []
          end

        end
      end
    end
  end
end