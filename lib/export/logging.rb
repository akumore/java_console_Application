module Export
  module Logging

    def init_logging
      set_log Rails.root.join("log", "exporter_#{Rails.env}.log")
      logger.formatter = Logger::Formatter.new
      logger.level = Logger::DEBUG #TODO Decrease log level when we know that it works ;)
    end

  end
end
