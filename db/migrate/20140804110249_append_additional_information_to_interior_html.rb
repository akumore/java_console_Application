class AppendAdditionalInformationToInteriorHtml < Mongoid::Migration
  Information.class_eval do
    field :additional_information, :type => String
  end

  def self.up
    RealEstate.all.each do |re|
      i = re.information
      next unless i
      next unless i.additional_information
      i.interior_html = i.interior_html.to_s + i.additional_information
      i.interior_html = i.interior_html.gsub(/<\/ul>\s*<ul>/m, '')
      i.unset(:additional_information)
      i.save!
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
