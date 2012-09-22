require 'singleton'

module Satellite
  module DB
    class Store
      include Singleton
      attr_reader :tables

      def initialize
        @tables = {}
      end

      def self.table(name)
        instance.tables[name] ||= {}
      end

    end
  end
end