class RealEstatesController < ApplicationController

  def index
    @real_estates = RealEstate.all
  end

end
