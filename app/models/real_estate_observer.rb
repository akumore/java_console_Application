class RealEstateObserver < Mongoid::Observer

  def after_create(real_estate)
    expire_cache_for(real_estate)
  end

  def after_update(real_estate)
    expire_cache_for(real_estate)
  end

  def after_destroy(real_estate)
    expire_cache_for(real_estate)
  end

  def expire_cache_for(real_estate)
    I18n.available_locales.each do |locale|
      %w(html pdf).each do |format|
        context.expire_page(cache_key_for(real_estate, format, locale))
      end
    end
  end

  def context
    @context ||= ActionController::Base.new
  end

  private

  def cache_key_for(real_estate, format, locale)

    decorated_real_estate = RealEstateDecorator.new(real_estate)

    Rails.application.routes.url_helpers.real_estate_object_documentation_path(
      :real_estate_id => real_estate.id,
      :format => format,
      :name => decorated_real_estate.object_documentation_title,
      :locale => locale
    )
  end
end
