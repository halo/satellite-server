module Satellite
  module Server
    module Models
      module Object
        module Physics
          module Radian
            extend self

            # Keep in mind that down the screen is positive y, which means that PI/2 radians,
            # which you might consider the top in the traditional Trig unit circle sense is actually
            # the bottom; thus 3PI/2 is the top
            def top
              3 * Math::PI / 2.0
            end

          end
        end
      end
    end
  end
end