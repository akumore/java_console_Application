class Handout
  extend ActiveModel::Naming

  attr_reader :real_estate

  def initialize(real_estate)
    @real_estate = real_estate
  end

  def filename
    "Objektdokumentation-#{real_estate.title.parameterize}"
  end

  def cache_key(format, locale)
    Rails.application.routes.url_helpers.real_estate_handout_path(
      :real_estate_id => real_estate.id,
      :format => format,
      :locale => locale
    )
  end

  def to_pdf
    PDFKit.new(Rails.application.routes.url_helpers.real_estate_handout_url(
      :locale => I18n.locale,
      :real_estate_id => @real_estate.id,
      :format => :html)).to_pdf
  end

end
