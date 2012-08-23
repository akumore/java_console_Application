class Handout
  extend ActiveModel::Naming

  attr_reader :real_estate

  def initialize(real_estate)
    @real_estate = real_estate
  end

  def filename
    "Objektdokumentation-#{real_estate.title.parameterize}"
  end

  def path

  end

  def url

  end

  def cache_key(format, locale)
    Rails.application.routes.url_helpers.real_estate_object_documentation_path(
      :real_estate_id => real_estate.id,
      :format => format,
      :name => real_estate.handout.filename,
      :locale => locale
    )
  end
end
