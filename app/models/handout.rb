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
end
