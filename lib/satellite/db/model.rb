require 'active_model'
require 'satellite/db/persistence'
require 'satellite/extensions/core/object/random'

module Satellite
  module DB
    class Model
      include Persistence
      include ActiveModel::Serializers::JSON

      attr_accessor :id

      def initialize(attributes={})
        @id = attributes[:id] || random_id
      end

      def self.export(options={})
        map { |candidate| candidate.export(options) }
      end

      def export(*args)
        if args.detect { |arg| !arg.is_a?(Symbol) }
          options = { only: args }
        else
          options = {}
        end
        as_json(options)
      end

      private

      def include_root_in_json
        false
      end

    end
  end
end