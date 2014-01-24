class ApplicationDecorator < Draper::Base

  # !!! Avoid using methods that will be delegated to @model,
  # !!! this will define an unwanted method on application
  # !!! decorator and will break some tests/templates

  def field_list_in_real_estate_language(field)
    old_lang = I18n.locale
    begin
      I18n.locale = @model.real_estate.language.to_sym
      self.send(field).map {|c| "\t" + h.content_tag(:li, c) }
    ensure
      I18n.locale = old_lang
    end
  end

  def update_list_in(list_field, html_field)
    original_html = @model.send(html_field)
    info = original_html.split(/\r\n|\n/)

    index_of_ul_end = info.index('</ul>')
    if index_of_ul_end.nil?
      lis_before = []
    else
      object_name = model_class.to_s.tableize
      original = RealEstate.find(real_estate.id).send(object_name).decorate
      lis_before = original.field_list_in_real_estate_language(list_field)
    end
    lis_after = field_list_in_real_estate_language(list_field)

    to_add = lis_after - lis_before
    if to_add.length > 0 && index_of_ul_end.nil?
      info = ['<ul>','</ul>'] + info
      index_of_ul_end = 1
    end
    to_add.reverse.each {|li|
      info.insert(index_of_ul_end, li)
    }

    to_remove = lis_before - lis_after
    to_remove.each {|li|
      info.delete(li)
    }

    new_html = info.join("\r\n")
    @model.send("#{html_field}=", new_html)

    # return weather the function changed someting
    original_html.gsub("\r",'').strip != new_html.gsub("\r", '').strip
  end

end
