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

  def update_list_in(list_field)
    CharacteristicsHtml.new(self, list_field).update
  end

end
