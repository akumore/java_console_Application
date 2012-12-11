class RealEstateExhibit < SimpleDelegator

  def self.create(instance, offer, utilization)
    klass_string = "#{offer.to_s.classify}::#{utilization.to_s.classify}::#{instance.class.name}Exhibit"
    klass_string.constantize
  end

  attr_reader :context, :model

  def initialize(model, context, locals = {})
    @context = context
    @model = model
    @locals = locals
    super(model)
  end

  def render(attribute, options = {})
    defaults = { :model => @model }
    options.merge!(defaults)
    options.merge!(@locals)
    context.render(:partial => partial_for_attribute(attribute), :locals => options)
  end

  def partial_for_attribute(attribute_name)
    attribute_name.to_s
  end

  def class
    @model.class
  end
end
