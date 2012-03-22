module RealEstatesHelper

  def cantons_for_collection_select(cantons)
    cantons.map {|canton| [canton, t("cantons.#{canton}")]}
  end

end