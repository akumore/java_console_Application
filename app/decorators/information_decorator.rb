class InformationDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :information

  def available_from
    date = if model.display_estimated_available_from.present?
      model.display_estimated_available_from
    elsif model.available_from.present?
      I18n.l(model.available_from)
    end

    I18n.t('information.available_from', :date => date) if date
  end
end
