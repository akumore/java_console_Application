class AppendAdditionalInformationToInteriorHtml < Mongoid::Migration
  def self.up
    RealEstate.all.each do |re|
      i = re.information
      next unless i
      next unless i.additional_information
      i.interior_html = i.interior_html.to_s + i.additional_information
      i.unset(:additional_information)
      i.save!
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
