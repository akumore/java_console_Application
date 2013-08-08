class ConvertMarkdownToHtml < Mongoid::Migration
  def self.up
    ConvertMarkdownToHtml.convert_real_estate_attributes
    ConvertMarkdownToHtml.convert_page_brick_attributes
    ConvertMarkdownToHtml.convert_job_attributes
    ConvertMarkdownToHtml.convert_news_item_attributes
  end

  def self.down
  end

  def self.convert_real_estate_attributes
    RealEstate.all.each do |real_estate|
      if real_estate.description.present?
        real_estate.description = ConvertMarkdownToHtml.convert(real_estate.description)
      end

      if real_estate.utilization_description.present?
        real_estate.utilization_description = ConvertMarkdownToHtml.convert(real_estate.utilization_description)
      end

      if real_estate.additional_description.present?
        ConvertMarkdownToHtml.convert_additional_description_attributes(real_estate)
      end

      real_estate.save
    end
  end

  def self.convert_additional_description_attributes real_estate
    if real_estate.additional_description.location.present?
      real_estate.additional_description.location = ConvertMarkdownToHtml.convert(real_estate.additional_description.location)
    end

    if real_estate.additional_description.interior.present?
      real_estate.additional_description.interior = ConvertMarkdownToHtml.convert(real_estate.additional_description.interior)
    end

    if real_estate.additional_description.offer.present?
      real_estate.additional_description.offer = ConvertMarkdownToHtml.convert(real_estate.additional_description.offer)
    end

    if real_estate.additional_description.infrastructure.present?
      real_estate.additional_description.infrastructure = ConvertMarkdownToHtml.convert(real_estate.additional_description.infrastructure)
    end

    real_estate.additional_description.save
  end

  def self.convert_page_brick_attributes
    Page.all.each do |page|
      page.bricks.all.each do |brick|
        if brick.type == 'accordion' || brick.type == 'text'
          brick.text = ConvertMarkdownToHtml.convert(brick.text)

          if brick.type == 'text'
            brick.more_text = ConvertMarkdownToHtml.convert(brick.more_text)
          end

          brick.save
        end
      end
    end
  end

  def self.convert_job_attributes
    Job.all.each do |job|
      if job.text.present?
        job.text = ConvertMarkdownToHtml.convert(job.text)
        job.save
      end
    end
  end

  def self.convert_news_item_attributes
    NewsItem.all.each do |news_item|
      if news_item.content.present?
        news_item.content = ConvertMarkdownToHtml.convert(news_item.content)
        news_item.save
      end
    end
  end

  def self.convert string
    RDiscount.new(string).to_html.gsub(/>\s+/, '>')
  end
end
