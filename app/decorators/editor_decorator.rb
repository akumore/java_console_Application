class EditorDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :cms_user, :class => Cms::User

  def full_name
    if %w(admin editor).include? model.first_name.downcase
      'Unbekannt'
    else
      "#{model.first_name} #{model.last_name}"
    end
  end
end
