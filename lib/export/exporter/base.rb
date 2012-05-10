module Export
  module Exporter
    class Base < Logger::Application
      include Logging

      def initialize(dispatcher, appname = nil)
        super appname
        init_logging

        dispatcher.add_observer(self)
      end

    end
  end
end