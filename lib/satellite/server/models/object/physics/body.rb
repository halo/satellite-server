require 'chipmunk'

module Satellite
  module Server
    module Models
      module Object
        module Physics
          class Body < CP::Body

            def initialize(options={})
              super options[:mass], options[:inertia]
            end

          end
        end
      end
    end
  end
end