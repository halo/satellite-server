require 'satellite/db/store'
require 'active_support/concern'

# Inspired by https://github.com/rails/rails/blob/master/activerecord/lib/active_record/persistence.rb
module Satellite
  module DB
    module Persistence
      extend ActiveSupport::Concern

      module ClassMethods
        include Enumerable

        def create(attributes={})
          object = new(attributes)
          object.save
          object
        end

        def create_or_update(attributes={})
          if object = find(attributes[:id])
            object.update_attributes(attributes)
          else
            create attributes
          end
        end

        def find(id)
          table[id]
        end

        def destroy(id)
          table.delete(id)
        end

        def destroy_all
          table.clear
        end

        def each(&block)
          if block_given?
            table.values.each { |record| yield record }
          else
            table.values
          end
        end

        def all(*args, &block)
          each(*args, &block)
        end

        def self.as_json(*args)
          all.map { |object| object.as_json(*args) }
        end

        def last
          all.last
        end

        def table
          Store.table(table_name)
        end

        def table_name
          ActiveSupport::Inflector.tableize(name)
        end

      end

      def save
        self.class.table[self.id] = self
      end

      def update_attributes(attributes={})
        attributes.each do |key, value|
          update_attribute(key, value)
        end
      end

      def read_attribute(name)
        instance_variable_get '@'.concat(name.to_s).to_sym
      end

      def update_attribute(name, value)
        instance_variable_set '@'.concat(name.to_s).to_sym, value
      end

      def destroy
        self.class.table.delete(self.id)
      end

      private

      def attributes
        attribute_names.inject({}) { |result, name| result[name] = read_attribute(name); result }
      end

      def attribute_names
        instance_variables.map do |instance_variable|
          instance_variable.to_s.gsub('@', '')
        end
      end

    end
  end
end