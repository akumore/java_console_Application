class RealEstateExhibit

  def self.create(instance, offer, utilization)
    klass_string = "#{offer.to_s.classify}::#{utilization.to_s.classify}::#{instance.class.name}Exhibit"
    klass_string.constantize
  end

  attr_reader :context


  def initialize(model, context)
    @context = context
    @model = model
  end

  def render(attribute, options = {})
    defaults = {}
    options.merge!(defaults)
    context.render(partial_for_attribute(attribute), :locals => options)
  end

  def partial_for_attribute(attribute_name)
    attribute_name
  end

  def method_missing(method, *args)
    if respond_to?(method)
      @model.send method, *args
    else
      super
    end
  end
end
