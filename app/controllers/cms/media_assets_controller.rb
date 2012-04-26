class Cms::MediaAssetsController < Cms::SecuredController
  include Concerns::EmbeddedInRealEstate

  def index
    #images are accessed using the form builder
    @floor_plans = @real_estate.floor_plans
    @videos = @real_estate.videos
    @documents = @real_estate.documents
  end
end
