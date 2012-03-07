module EmbeddedInRealEstate
  extend ActiveSupport::Concern

  included do
    before_filter :load_real_estate
  end

  def load_real_estate
    @real_estate = RealEstate.find(params[:real_estate_id])
  end
end