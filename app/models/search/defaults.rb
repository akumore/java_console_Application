module Search
  class Defaults

    include Utilization::Accessors
    attr_accessor :utilization

    def initialize(utilization)
      @utilization = utilization
    end

    def sort_field
      if working? || storing?
        'usable_surface'
      else
        'rooms'
      end
    end

  end
end
