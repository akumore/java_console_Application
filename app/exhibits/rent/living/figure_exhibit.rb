module Rent
  module Living
    class FigureExhibit < RealEstateExhibit

      def render_floor_input
        render(:floor, :mandatory => false)
      end
    end
  end
end
