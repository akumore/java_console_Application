module Export
  class Dispatcher
    include Observable

    def run
      exportable_real_estates.each do |real_estate|
        changed
        notify_observers(:add, real_estate)
      end

      changed
      notify_observers :finish

      Rails.logger.info 'Export has finished at ' + I18n.l(Time.now)
    end

    private

    def exportable_real_estates
      RealEstate.published
    end
  end
end
