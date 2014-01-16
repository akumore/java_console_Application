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
    if can?(:edit, @real_estate)

      primary.item :real_estate, 'Stammdaten', edit_cms_real_estate_path(@real_estate),
                   :highlights_on=> lambda { controller_name=='real_estates' && ['edit', 'update'].include?(action_name)},
          :class=>'mandatory'

      [:address, :information, :pricing, :figure, :infrastructure, :additional_description].each do |submodel|
        action = @real_estate.send(submodel).present? ? :edit : :new
        path = "#{action}_cms_real_estate_#{submodel}_path"
        primary.item submodel, t("navigation.cms.real_estates_navigation.#{submodel}"), send(path, @real_estate),
                     :class => "#{highlight_invalid_tab(submodel)} #{mark_mandatory_tab(submodel)}",
                     :highlights_on => Regexp.new("#{submodel}"), :if => Proc.new { @real_estate.to_model_access.accessible?(submodel) }
      end

    else

      primary.item :real_estate, t('navigation.cms.real_estates_navigation.real_estate'), cms_real_estate_path(@real_estate)
      primary.item :address, t('navigation.cms.real_estates_navigation.address'), cms_real_estate_address_path(@real_estate)
      primary.item :information, t('navigation.cms.real_estates_navigation.information'), cms_real_estate_information_path(@real_estate)
      primary.item :pricing, t('navigation.cms.real_estates_navigation.pricing'), cms_real_estate_pricing_path(@real_estate)
      primary.item :figure, t('navigation.cms.real_estates_navigation.figure'), cms_real_estate_figure_path(@real_estate), :if => Proc.new { @real_estate.to_model_access.accessible?(:figure) }
      primary.item :infrastructure, t('navigation.cms.real_estates_navigation.infrastructure'), cms_real_estate_infrastructure_path(@real_estate), :if => Proc.new { @real_estate.to_model_access.accessible?(:infrastructure) }
      primary.item :additional_description, t('navigation.cms.real_estates_navigation.Beschreibungen'), cms_real_estate_additional_description_path(@real_estate), :if => Proc.new { @real_estate.to_model_access.accessible?(:additional_description) }

    end

    primary.item :media_assets, 'Bilder & Dokumente', cms_real_estate_media_assets_path(@real_estate), :highlights_on => /media_assets|image|video|document/

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    primary.dom_class = 'nav nav-tabs'

  end

end
