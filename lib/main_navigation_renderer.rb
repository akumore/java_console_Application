class MainNavigationRenderer < SimpleNavigation::Renderer::List

  # copied from gem: andi/simple-navigation/blob/master/lib/simple_navigation/rendering/renderer/list.rb

  def render(item_container)
    list_content = item_container.items.inject([]) do |list, item|
      li_options = item.html_options.reject {|k, v| k == :link}
      li_content = tag_for(item)
      if include_sub_navigation?(item)
        li_content << content_tag(:div, content_tag(:div, render_sub_navigation_for(item), { :class => 'sub-navigation' }), { :class => 'sub-navigation-wrapper' })
      end
      list << content_tag(:li, li_content, li_options)
    end.join

    if skip_if_empty? && item_container.empty?
      ''
    else
      content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => item_container.dom_id, :class => item_container.dom_class})
    end
  end
end
