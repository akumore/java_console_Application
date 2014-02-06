class ApplicationDecorator < Draper::Base

  # !!! Avoid using methods that will be delegated to @model,
  # !!! this will define an unwanted method on application
  # !!! decorator and will break some tests/templates

  def field_list_in_real_estate_language(field)
    real_estate = @model.real_estate
    real_estate.within_language do
      self.send(field).map {|c| "\t" + h.content_tag(:li, c) }
    end
  end

  def translate_characteristics(fields)
    field_access = context[:field_access] || controller.field_access
    buffer = []
    object_name = model_class.to_s.tableize

    fields.each {|field|
      next unless field_access.accessible?(model, field)
      value = self.send(field)
      next if value.blank?

      translated = t("#{object_name}.#{field}") 
      case
      when self.method(field).arity > -1
        # expect this function is defined in the decorator itself
        # which formats and translates the value userfriendly
        buffer << value
      when translated.is_a?(Hash)
        buffer << t("#{object_name}.#{field}", :count => value)
      when value.is_a?(Boolean)
        buffer << translated if value
      else
        buffer << translated + ': ' + value.to_s
      end
    }

    buffer
  end

  def update_list_in(list_field, html_field)
    original_html = @model.send(html_field).to_s
    info = original_html.split(/\r\n|\n/)

    lis_before = []
    unless @model.new_record?
      object_name = model_class.to_s.underscore
      original = RealEstate.find(real_estate.id).send(object_name).decorate
      lis_before = original.field_list_in_real_estate_language(list_field)
    end

    index_of_ul_end = info.index('</ul>')
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
    #binding.pry if html_field == :infrastructure_html
    @model.send("#{html_field}=", new_html)

    # return weather the function changed someting
    original_html.gsub("\r",'').strip != new_html.gsub("\r", '').strip
  end

end
