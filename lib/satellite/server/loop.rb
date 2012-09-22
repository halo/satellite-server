require 'satellite/log'
require 'satellite/extensions/core/time/milliseconds'

module Satellite
  module Server
    class Loop

      def initialize
        @updates_per_second = 60
        @updates = 0
      end

      # For an excellent article about game loops, see http://www.koonsolo.com/news/dewitters-gameloop
      def start(&block)
        Log.debug "Starting server loop with framerate #{@updates_per_second}..."
        @started_at = Time.now.to_ms
        next_game_tick = Time.now.to_ms
        loop do
          update_loops = 0
          while Time.now.to_ms > next_game_tick && update_loops < 5
            update { yield }
            next_game_tick += 1000 / @updates_per_second
            update_loops += 1
          end
        end
      end

      private

      def elapsed_milliseconds
        Time.now.to_ms - @started_at
      end

      def update(&block)
        @last_update_log ||= 0
        yield
        @updates += 1
        if @last_update_log + 1000 < elapsed_milliseconds
          Log.debug "Game update #{@updates}"
          @last_update_log = elapsed_milliseconds
        end
      end

    end
  end
end