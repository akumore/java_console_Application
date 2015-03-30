module CopyRealEstate

  def copy!(other)
    copied = other.clone #keep in mind this will also clone ids, created_at etc of embedded objects
    copied.state = RealEstate::STATE_EDITING
    copied.title = "Kopie von #{other.title}"
    copy_assets!(copied)
    copied.channels.delete(RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL)
    copied.save!
    copied
  end


  private
  def copy_assets!(copy_of_real_estate)
    [:images, :floor_plans, :videos, :documents].each do |assets|
      # WARING: map! seems not to work for embedded associations!!!
      copy_of_real_estate.send("#{assets}=", copy_of_real_estate.send(assets).map { |asset| asset.class.new extract_asset_params(asset) })
    end
  end

  def extract_asset_params(asset)
    [:title, :file, :is_primary, :position].inject({}) do |h, attr|
      h[attr] = asset.send(attr) if asset.respond_to?(attr)
      h
    end
  end

end
