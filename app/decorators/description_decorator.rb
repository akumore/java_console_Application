class DescriptionDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  decorates :real_estate

  def chapter
    content_html = ''

    unless real_estate.description.blank?
      content_html << markdown(real_estate.description)
    end

    additional_description = real_estate.additional_description
    if additional_description.present?
      if additional_description.location.present?
        content_html << content_tag(:h3, t('additional_descriptions.location'))
        content_html << markdown(additional_description.location)
      end

      if additional_description.interior.present?
        content_html << content_tag(:h3, t('additional_descriptions.interior'))
        content_html << markdown(additional_description.interior)
      end

      if additional_description.offer.present?
        content_html << content_tag(:h3, t('additional_descriptions.offer'))
        content_html << markdown(additional_description.offer)
      end

      if additional_description.infrastructure.present?
        content_html << content_tag(:h3, t('additional_descriptions.infrastructure'))
        content_html << markdown(additional_description.infrastructure)
      end
    end

    {
      :title        => real_estate.title,
      :collapsible  => false,
      :content_html => content_html
    }
  end

end
