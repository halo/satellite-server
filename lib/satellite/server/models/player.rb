require 'satellite/db/model'

module Satellite
  module Server
    module Models
      class Player < Satellite::DB::Model
        attr_reader :keyboard, :mouse
        attr_accessor :object

        def initialize(options={})
          super
          @keyboard = Set.new
          @mouse = Set.new
          @object = options[:object]
        end

        def input=(input)
          @keyboard = input.keyboard
          @mouse = input.mouse
        end

        def holding?(key)
          keyboard.include? key
        end

      end
    end
  end
end