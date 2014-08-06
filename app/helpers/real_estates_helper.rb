module RealEstatesHelper

  def authorized_real_estates
    # Allow local requests for pdf generation
    return RealEstate if request.local?
    return RealEstate if user_signed_in?
    RealEstate.published
  end

  def cantons_for_collection_select(cantons)
    cantons.map {|canton| [canton, t("cantons.#{canton}")]}
  end

  def offer_select_options
    [
      [t("real_estates.search_filter.for_rent"), Offer::RENT],
      [t("real_estates.search_filter.for_sale"), Offer::SALE]
    ]
  end

  def utilization_select_options
    [
      [t("real_estates.search_filter.living"), Utilization::LIVING],
      [t("real_estates.search_filter.working"), Utilization::WORKING],
      [t("real_estates.search_filter.storing"), Utilization::STORING],
      [t("real_estates.search_filter.parking"), Utilization::PARKING]
    ]
  end

  def category_options_for_utilization(utilization)
    Category.unscoped.where(utilization: utilization).sorted_by_utilization.map { |c|[c.label, c.id, { 'data-category_name' => c.name }] }
  end

  def microsite_select_options
    MicrositeBuildingProject.all.map do |microsite_building_project|
      [
        t("cms.real_estates.form.microsite_building_projects.#{microsite_building_project}"),
        microsite_building_project
      ]
    end
  end

  def zoomed_div(floorplan, &block)
    content_tag :div, :class => "floorplan-zoomed", :id => "floorplan-zoomed-#{floorplan.id}" do
      block.call
    end
  end

  def caption_css_class_for_text(text)
    text.length > 25 ? 'flex-caption wide' : 'flex-caption'
  end
end
