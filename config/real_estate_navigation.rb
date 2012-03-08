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

    submodels = %w(address information pricing figure infrastructure descriptions)
    invalid_submodels = @real_estate.invalid_submodels
    
    primary.item :real_estate, t('navigation.cms.real_estates_navigation.real_estate'), edit_cms_real_estate_path(@real_estate)

    submodels.each do |submodel|
      action = @real_estate.send(submodel).present? ? :edit : :new
      path = "#{action}_cms_real_estate_#{submodel.singularize}_path"
      primary.item submodel, t("navigation.cms.real_estates_navigation.#{submodel}"), send(path, @real_estate), 
        :class => (invalid_submodels.include?(submodel) ? 'invalid' : nil),
        :highlights_on => Regexp.new(submodel.singularize)
    end

    primary.item :media_assets, t('navigation.cms.real_estates_navigation.media_assets'), cms_real_estate_media_assets_path(@real_estate), :highlights_on => /media_assets|image|video|document/

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    primary.dom_class = 'nav nav-tabs'

  end

end
