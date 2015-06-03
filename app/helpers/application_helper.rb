# encoding: utf-8

module ApplicationHelper

  def path_to_url(path)
      request.protocol + request.host_with_port + path
  end

  def footer_news_item_link(news_item)
    if request.path == news_items_path
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}"), :onclick => "$('#news_item_#{news_item.id} .title').click();"
    else
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}")
    end
  end

  def jobs_subnavigation
    if jobs_page = Page.jobs_page
      jobs_page.subnavigation.each do |page|
        yield page
      end
    end
  end

  def company_subnavigation
    if company_page = Page.company_page
      company_page.subnavigation.each do |page|
        yield page
      end
    end
  end

  def non_caching_image_tag(source, options = {})
    image_tag "#{source}?id=#{Random.new.rand(1_000..10_000-1)}", options
  end

  def floated_field_show(model, field, options = {})
    return '' unless accessible?(field)

    haml_tag(:dl, class: 'dl-horizontal') do
      haml_tag(:dt, t("mongoid.attributes.#{model.class.name.tableize}.#{field}"))
      value = model.send(field)
      value = t(value.to_s) if options[:translate_value] && value.to_s.present?
      haml_tag(:dd, value)
    end
  end

  def parking_field_visible?(real_estate, field)
    return true unless real_estate.parking?
    category_name = real_estate.category.name
    category_name == field.to_s || "#{category_name}_spots" == field.to_s
  end


  def parking_floated_field(form, type, field, options = {})
    real_estate = form.object.real_estate
    # do not render if realestate is parking and the current
    # parking spot field does not match the category
    return '' unless parking_field_visible?(real_estate, field)

    floated_field(form, type, field, options)
  end

  def floated_field(form, type, field, options = {})
    return '' unless accessible?(field)

    haml_tag('.control-group', :class => options.delete(:mandatory) ? 'mandatory' : '') do
      haml_concat form.label(field)
      haml_tag('.controls') do
        haml_concat form.send(type, field, options)
        yield if block_given?
      end
    end
  end

  def get_forum_brick
    Page.find(t('company_page_id')).bricks.find(t('current_forum_brick_id'))
  rescue Mongoid::Errors::DocumentNotFound
    false
  end

  def css_class_for_same_teaser_height(first_teaser, second_teaser)
    return unless first_teaser.present? && second_teaser.present?
    'teasers-have-same-height'
  end
end
