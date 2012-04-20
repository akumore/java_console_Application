class AddressDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :address

  def simple
    [street, city].compact.join ' '
  end

  def street
    [model.street, model.street_number].compact.join ' '
  end

  def simple_city
    [model.zip, model.city].compact.join ' '
  end

  def extended_city
    [simple_city, model.canton.upcase].compact.join ' '
  end
end
