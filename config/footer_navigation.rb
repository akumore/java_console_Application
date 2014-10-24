SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'selected'
  navigation.active_leaf_class = nil
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|

    primary.item :real_estate, t('navigation.main.real_estate'), real_estates_path, :highlights_on => proc { controller.request.path.include?('real_estate') }
    primary.item :jobs, t('navigation.main.jobs'), t('jobs_url'), :highlights_on => proc { controller.request.path == I18n.t('jobs_url') }
    primary.item :company, t('navigation.main.company'), t('company_url'), :highlights_on => proc { controller.request.path == I18n.t('company_url') }
    primary.item :news, t('navigation.main.news'), news_items_path, :highlights_on => proc { controller.request.path == news_items_path }
    primary.item :reference_projects, t('navigation.main.reference_projects'), reference_projects_path, :highlights_on => proc { controller.request.path == reference_projects_path }
    primary.item :contact, t('navigation.meta.contact'), t('contact_url')

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    primary.dom_class = 'footer-navigation'

    # You can turn off auto highlighting for a specific level
    primary.auto_highlight = false
  end
end
