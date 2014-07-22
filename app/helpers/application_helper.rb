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

  def insert_seo_tags
    seo_tags_html = ""
    if request.path == '/de/jobs'
      seo_tags_html << content_tag(:title, "#{@page.title} - Bauleiter, Projektleiter, Immobilienverwalter, Immobilienbewirtschafter, Immobilienberater")
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Wir sind ein Familienunternehmen, das den Menschen mit Wertschätzung begegnet. Mitarbeitende, Kunden und Partner stehen im Zentrum unserer Tätigkeit. Unseren Mitarbeitenden bieten wir ein kollegiales und förderndes Arbeitsklima. Dazu gehört, dass wir ihnen herausfordernde Aufgaben übertragen und das nötige Vertrauen schenken, damit sie ihre Aufgaben unternehmerisch erfüllen können.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Bauleiter, Projektleiter, Immobilienverwalter, Immobilienbewirtschafter, Immobilienberater')
    elsif request.path == '/de/company'
      seo_tags_html << content_tag(:title, "#{@page.title} - Projektentwicklung, Baurealisierung, Vermarktung, Bewirtschaftung, Umbau und Renovation")
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Wir bieten unseren Kunden reibungsloses Projektmanagement an. Qualität, Seriosität und Fairness stehen bei der Alfred Müller AG an oberster Stelle – deshalb ist sie für ihre Kunden in jedem Moment eine zuverlässige Partnerin.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Projektentwicklung, Baurealisierung, Vermarktung, Bewirtschaftung, Umbau und Renovation')
    elsif request.path == '/de/contact'
      seo_tags_html << content_tag(:title, "#{@page.title} - Alfred Müller Immobilien")
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Für alle Ihre Immobilienfragen haben wir eine Antwort. Nehmen Sie mit uns Kontakt auf.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Land, Grundstücke, Immobilien, bauen, mieten, kaufen, vermieten, Immobilienverwaltung, umbauen und renovieren')
    end
    seo_tags_html.html_safe
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
    begin
      Page.find(t('company_page_id')).bricks.find(t('current_forum_brick_id'))
    rescue Mongoid::Errors::DocumentNotFound
      false
    end
  end

  def render_retargeting_pixels?
    Rails.env.production? &&
    current_page?(controller: 'real_estates',
                  action: 'index',
                  offer: Offer::RENT,
                  utilization: Utilization::WORKING)
  end
end
