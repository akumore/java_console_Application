class TabList

  def initialize(real_estate)
    @real_estate = real_estate
  end

  def get_available_tabs
    existing_tabs = ['address', 'information', 'pricing', 'figure', 'infrastructure', 'additional_description', 'media_assets']
    existing_tabs.select { |tab| @real_estate.to_model_access.accessible?(tab) }
  end

  def next_step(name)
    get_available_tabs[get_available_tabs.index(name) + 1]
  end
end
