module Utilization

  LIVING  = 'private'
  WORKING = 'commercial'
  STORING = 'storage'
  PARKING = 'parking'

  def self.all
    [LIVING, WORKING, STORING, PARKING]
  end

  module Accessors
    def living?
      utilization == LIVING
    end

    def commercial?
      working?
    end

    def non_commercial?
      living?
    end

    def working?
      utilization == WORKING
    end

    def storing?
      utilization == STORING
    end

    def parking?
      utilization == PARKING
    end
  end
end
