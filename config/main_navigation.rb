# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = nil

  # Item keys are normally added to list items as id.
  # This setting turns that off
  navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|

    primary.item :real_estate, t('navigation.main.real_estate'), real_estates_path
    primary.item :jobs, t('navigation.main.jobs'), root_path
    primary.item :company, t('navigation.main.company'), root_path
    primary.item :services, t('navigation.main.services'), root_path
    primary.item :news, t('navigation.main.news'), root_path
    primary.item :knowledge, t('navigation.main.knowledge'), root_path

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    primary.dom_class = 'main-navigation'

    # You can turn off auto highlighting for a specific level
    primary.auto_highlight = false

  end

end
