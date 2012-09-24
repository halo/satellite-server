module Satellite
  module Server
    module Controllers
      module Managers
        class Broker

          # Public: A simple container to contain a message.
          class Message
            def initialize(options={})
              @kind = options[:kind]
              @data = options[:data]
            end
          end

          # Internal: Message queue container.
          attr_reader :queue

          # Internal: Instances of the consumers.
          attr_reader :consumers

          def initialize
            reset!
          end

          def add_consumer(consumer)
            @consumers << consumer
          end

          def <<(message)
            raise "This is not a message: #{message}" unless message.is_a?(Message)
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

          # Internal: Rrset consumers and message queue. Useful for testing.
          def reset!
            @queue = []
            @consumers = []
          end

        end
      end
    end
  end
end