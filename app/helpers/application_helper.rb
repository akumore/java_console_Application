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
      jobs_page.subnavigation.each do |title|
        yield title
      end
    end
  end

  def company_subnavigation
    if company_page = Page.company_page
      company_page.subnavigation.each do |title|
        yield title
      end
    end
  end

  def non_caching_image_tag(source, options = {})
    image_tag "#{source}?id=#{Random.new.rand(1_000..10_000-1)}", options
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
