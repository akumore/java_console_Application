module Export
  module Exporter
    class Base

      def initialize(dispatcher)
        dispatcher.add_observer(self)
      end
      
    end
  end
end