module ApplicationHelper

  def markdown string
    RDiscount.new(string).to_html.html_safe
  end

  def path_to_url(path)
      request.protocol + request.host_with_port + path
  end

  def footer_news_item_link(news_item)
    if request.path == news_items_path
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}"), :onclick => "$('#news_item_#{news_item.id} .title').click(); return false"
    else
      link_to t(".get_more"), news_items_path(:anchor => "news_item_#{news_item.id}")
    end
  end

  def insert_seo_tags
    seo_tags_html = ""
    if request.path == '/de/jobs'
      seo_tags_html << content_tag(:title, 'Jobs - Bauleiter, Projektleiter, Immobilienverwalter, Immobilienbewirtschafter, Immobilienberater')
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Wir sind ein Familienunternehmen, das den Menschen mit Wertsch&auml;tzung begegnet. Mitarbeitende, Kunden und Partner stehen im Zentrum unserer T&auml;tigkeit. Unseren Mitarbeitenden bieten wir ein kollegiales und f&ouml;rderndes Arbeitsklima. Dazu geh&ouml;rt, dass wir ihnen herausfordernde Aufgaben &uuml;bertragen und das n&ouml;tige Vertrauen schenken, damit sie ihre Aufgaben unternehmerisch erf&uuml;llen k&ouml;nnen.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Bauleiter, Projektleiter, Immobilienverwalter, Immobilienbewirtschafter, Immobilienberater')
    elsif request.path == '/de/company'
      seo_tags_html << content_tag(:title, 'Unternehmen - Projektentwicklung, Baurealisierung, Vermarktung, Bewirtschaftung, Umbau und Renovation')
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Wir bieten unseren Kunden reibungsloses Projektmanagement an. Qualit&auml;t, Seriosit&auml;t und Fairness stehen bei der Alfred M&uuml;ller AG an oberster Stelle &ndash; deshalb ist sie f&uuml;r ihre Kunden in jedem Moment eine zuverl&auml;ssige Partnerin.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Projektentwicklung, Baurealisierung, Vermarktung, Bewirtschaftung, Umbau und Renovation')
    elsif request.path == '/de/contact'
      seo_tags_html << content_tag(:title, 'Kontakt - Alfred M&uuml;ller Immobilien')
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'F&uuml;r alle Ihre Immobilienfragen haben wir eine Antwort. Nehmen Sie mit uns Kontakt auf.')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Land, Grundst&uuml;cke, Immobilien, bauen, mieten, kaufen, vermieten, Immobilienverwaltung, umbauen und renovieren')
    else
      seo_tags_html << content_tag(:title, 'Alfred M&uuml;ller Immobiliendienstleistungen')
      seo_tags_html << content_tag(:meta, nil, :name => 'description', :content => 'Die Alfred M&uuml;ller AG, Baar, z&auml;hlt zu den f&uuml;hrenden Immobiliendienstleistern der Schweiz, mit Filialen in Marin und Camorino. Die Alfred M&uuml;ller AG akquiriert und entwickelt Grundst&uuml;cke, sie plant, realisiert, vermarktet, bewirtschaftet und renoviert Liegenschaften. ')
      seo_tags_html << content_tag(:meta, nil, :name => 'keywords', :content => 'Land, Grundst&uuml;cke, Immobilien, bauen, mieten, kaufen, vermieten, Immobilienverwaltung, umbauen und renovieren')
    end
    seo_tags_html.html_safe
  end

end
