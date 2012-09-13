module Export
  class Dispatcher < Logger::Application
    include Observable
    include Logging

    def initialize(appname = nil)
      super
      init_logging
    end

    def run
      exportable_real_estates.each do |real_estate|
        logger.info "Adding published real estate #{real_estate.id} as possible export target"
        changed and notify_observers(:add, real_estate)
      end

      changed and notify_observers :finish
      true
    end


    private
    def exportable_real_estates
      RealEstate.published
    end
  end
end
