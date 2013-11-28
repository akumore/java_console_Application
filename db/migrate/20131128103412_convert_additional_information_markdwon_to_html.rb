class ConvertAdditionalInformationMarkdwonToHtml < Mongoid::Migration
  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.information.present? && real_estate.information.additional_information.present?
        real_estate.information.additional_information = ConvertAdditionalInformationMarkdwonToHtml.convert(real_estate.information.additional_information)
      end

      real_estate.save
    end
  end

  def self.down
  end

  def self.convert string
    RDiscount.new(string).to_html.gsub(/[\r\n\e]/m, '')
  end
end
