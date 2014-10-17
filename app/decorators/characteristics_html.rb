class CharacteristicsHtml
  attr_reader :list_field, :html_field, :decorator

  def self.merge(current, before, after)
    current = current.dup
    to_add = after - before
    to_add.each {|li|
      next if current.include?(li)

      # find the index of the closest li before current
      lis_before_current = after[0..after.index(li)][0..-2]
      closest = lis_before_current.reverse.find {|l| current.index(l) }

      if closest
        current.insert(current.index(closest) + 1, li)
        next
      end

      # find the index of the closest li after current
      lis_after_current = after[after.index(li)..-1][1..-1]
      closest = lis_after_current.find {|l| current.index(l) }

      if closest
        current.insert(current.index(closest), li)
        next
      end

      current.push(li)
    }
    to_remove = before - after
    to_remove.each {|li|
      current.delete(li)
    }
    current
  end

  # Will update the attribute "#{field}_html" with the list
  # values returned by "#{field}_characteristics"
  def initialize(decorator, field, options = {})
    @list_field = options[:list_field] || "#{field}_characteristics"
    @html_field = options[:html_field] || "#{field}_html"
    @decorator = decorator
    @original_html = @decorator.send(html_field).to_s
  end

  def original
    return nil if decorator.new_record?

    object_name = decorator.model_class.to_s.underscore
    decorator_class = (object_name + "_decorator").classify.constantize
    unchanged = RealEstate.find(decorator.real_estate.id).send(object_name)
    @original ||= decorator_class.new(unchanged)#, context: decorator.context)
  end

  def lis_before
    return [] unless original
    @lis_before ||= original.field_list_in_real_estate_language(list_field)
  end

  def lis_after
    @lis_after ||= decorator.field_list_in_real_estate_language(list_field)
  end

  def update
    return false unless decorator.valid?

    if original && original.real_estate.language != decorator.real_estate.language
      switch_language
    else
      update_list
    end
  end

  def switch_language
    info = @original_html.split(/\r\n|\n/)

    old_lis = lis_before
    new_lis = lis_after
    raise "Mapping not possible. (#{old_lis.length} != #{new_lis.length})" if old_lis.length != new_lis.length
    map = old_lis.zip(new_lis)
    map.each {|old_li, new_li|
      if index = info.index(old_li)
        info[index] = new_li
      end
    }
    write_field(info)
  end

  def update_list
    info = @original_html.split(/\r\n|\n/)
    index_of_ul_start = info.index('<ul>')
    index_of_ul_end = info.index('</ul>')

    to_add = lis_after - lis_before
    return if to_add.length == 0 && index_of_ul_start.nil?

    if index_of_ul_end.nil?
      info = ['<ul>','</ul>'] + info
      index_of_ul_start = 0
      index_of_ul_end = 1
    end

    # cut out current lis
    info_prefix = info[0..index_of_ul_start]
    current_lis = info[index_of_ul_start+1..index_of_ul_end-1]
    info_postfix = info[index_of_ul_end..-1]
    new_lis = self.class.merge(current_lis, lis_before, lis_after)

    info = info_prefix + new_lis + info_postfix
    write_field(info)
  end

  def write_field(new_list)
    new_html = new_list.join("\r\n")
    something_changed = @original_html.gsub("\r",'').strip != new_html.gsub("\r", '').strip

    decorator.send("#{html_field}=", new_html) if something_changed

    # return weather the function changed someting
    something_changed
  end

end
