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

  def to_pdf(url_params=ActionMailer::Base.default_url_options)
    url = Rails.application.routes.url_helpers.real_estate_handout_url(
      url_params.merge(
        :locale => I18n.locale,
        :real_estate_id => @real_estate.id,
        :format => :html
      ))
    PDFKit.new(url).to_pdf
  end

end
