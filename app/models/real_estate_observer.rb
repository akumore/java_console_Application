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
        context.expire_page(real_estate.handout.cache_key(format, locale))
      end
    end
  end

  def context
    @context ||= ActionController::Base.new
  end

end
