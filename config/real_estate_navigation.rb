# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  navigation.selected_class = nil

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = 'active'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  navigation.autogenerate_item_ids = false

  # Define the primary navigation
  navigation.items do |primary|

    invalid_submodels = @real_estate.invalid_submodels
    
    primary.item :real_estate, 'Stammdaten', edit_cms_real_estate_path(@real_estate)

    primary.item :address, 'Adresse', new_cms_real_estate_address_path(@real_estate), 
      :unless => lambda { @real_estate.address.present? }, 
      :highlights_on => /address/, 
      :class => (invalid_submodels.include?('address') ? 'invalid' : nil)

    primary.item :address, 'Adresse', edit_cms_real_estate_address_path(@real_estate), 
      :if => lambda { @real_estate.address.present? }, 
      :highlights_on => /address/, 
      :class => (invalid_submodels.include?('address') ? 'invalid' : nil)

    primary.item :information, 'Infos', new_cms_real_estate_information_path(@real_estate), 
      :unless => lambda { @real_estate.information.present? }, 
      :highlights_on => /information/,
      :class => (invalid_submodels.include?('information') ? 'invalid' : nil)

    primary.item :information, 'Infos', edit_cms_real_estate_information_path(@real_estate), 
      :if => lambda { @real_estate.information.present? }, 
      :highlights_on => /information/,
      :class => (invalid_submodels.include?('information') ? 'invalid' : nil)

    primary.item :pricing, 'Preise', new_cms_real_estate_pricing_path(@real_estate), 
      :unless => lambda { @real_estate.pricing.present? },
      :highlights_on => /pricing/,
      :class => (invalid_submodels.include?('pricing') ? 'invalid' : nil)

    primary.item :pricing, 'Preise', edit_cms_real_estate_pricing_path(@real_estate), 
      :if => lambda { @real_estate.pricing.present? }, 
      :highlights_on => /pricing/,
      :class => (invalid_submodels.include?('pricing') ? 'invalid' : nil)

    primary.item :figure, 'Zahlen und Fakten', new_cms_real_estate_figure_path(@real_estate), 
      :unless => lambda { @real_estate.figure.present? }, 
      :highlights_on => /figure/,
      :class => (invalid_submodels.include?('figure') ? 'invalid' : nil)

    primary.item :figure, 'Zahlen und Fakten', edit_cms_real_estate_figure_path(@real_estate), 
      :if => lambda { @real_estate.figure.present? }, 
      :highlights_on => /figure/,
      :class => (invalid_submodels.include?('figure') ? 'invalid' : nil)

    primary.item :infrastructure, 'Infrastruktur', new_cms_real_estate_infrastructure_path(@real_estate), 
      :unless => lambda { @real_estate.infrastructure.present? }, 
      :highlights_on => /infrastructure/,
      :class => (invalid_submodels.include?('infrastructure') ? 'invalid' : nil)

    primary.item :infrastructure, 'Infrastruktur', edit_cms_real_estate_infrastructure_path(@real_estate), 
      :if => lambda { @real_estate.infrastructure.present? }, 
      :highlights_on => /infrastructure/,
      :class => (invalid_submodels.include?('infrastructure') ? 'invalid' : nil)

    primary.item :descriptions, 'Beschreibungen', new_cms_real_estate_description_path(@real_estate), 
      :unless => lambda { @real_estate.descriptions.present? }, 
      :highlights_on => /description/,
      :class => (invalid_submodels.include?('descriptions') ? 'invalid' : nil)

    primary.item :descriptions, 'Beschreibungen', edit_cms_real_estate_description_path(@real_estate), 
      :if => lambda { @real_estate.descriptions.present? }, 
      :highlights_on => /description/,
      :class => (invalid_submodels.include?('descriptions') ? 'invalid' : nil)

    primary.item :media_assets, 'Bilder & Dokumente', cms_real_estate_media_assets_path(@real_estate), :highlights_on => /media_assets|image|video|document/

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    primary.dom_class = 'nav nav-tabs'

  end

end
