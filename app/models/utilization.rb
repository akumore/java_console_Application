require 'constants'

module Utilization
  include Constants::Utilization

  def self.all
    [LIVING, WORKING, STORING, PARKING]
  end

  module Accessors
    def living?
      utilization == Utilization::LIVING
    end

    def commercial?
      working?
    end

    def non_commercial?
      living?
    end

    def working?
      utilization == Utilization::WORKING
    end

    def storing?
      utilization == Utilization::STORING
    end

    def parking?
      utilization == Utilization::PARKING
    end
  end
end
