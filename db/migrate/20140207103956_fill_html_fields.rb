require 'application_controller'
require 'application_decorator'
require 'information_decorator'
require 'figure_decorator'

class FillHtmlFields < Mongoid::Migration
  FIELDS = {
    information: [:infrastructure, :interior, :location],
    figure:      [:offer]
  }

  def self.up
    ApplicationController.new.set_current_view_context
    RealEstate.all.each {|real_estate|

      puts real_estate.id
      field_access = FieldAccess.new(real_estate.offer, real_estate.utilization, FieldAccess.cms_blacklist)

      FIELDS.each {|object_name, fields|
        object = real_estate.send(object_name)
        next if object.nil?

        decorator = "#{object_name.to_s.classify}Decorator".constantize
        decorated = decorator.new(object, context: {field_access: field_access})

        fields.each {|field_name|
          lis = decorated.field_list_in_real_estate_language("#{field_name}_characteristics")
          next if lis.length == 0

          new_value = (["<ul>"] + lis + ["</ul>"]).join("\r\n") + object.send("#{field_name}_html").to_s
          new_value.gsub!(/<\/ul>\s*<ul>/m, '')
          object.send("#{field_name}_html=", new_value)
        }

        object.save(validation: false)
      }

    }
  end

  def self.down
  end
end
