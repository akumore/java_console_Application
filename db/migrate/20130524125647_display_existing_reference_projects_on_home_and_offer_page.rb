class DisplayExistingReferenceProjectsOnHomeAndOfferPage < Mongoid::Migration
  def self.up
    ReferenceProject.all.each do |reference_project|
      reference_project.displayed_on << ReferenceProject::HOME_AND_OFFER_PAGE
      reference_project.save
    end
  end

  def self.down
    ReferenceProject.all.each do |reference_project|
      reference_project.displayed_on.clear
      reference_project.save
    end
  end
end
