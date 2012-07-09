class ConvertRealEstatesToReferenceProjects < Mongoid::Migration
  extend ActionView::Helpers::TextHelper

  def self.up
    RealEstate.where(:channels => 'reference_projects').each do |real_estate|
      [:de, :en, :fr, :it].each do |locale|
        puts "Create Reference Project: #{real_estate.title}"
        ReferenceProject.create!(
          :title => truncate(real_estate.title, :length => 35),
          :locale => locale,
          :image => real_estate.images.primary.file,
          :real_estate => real_estate,
          :offer => real_estate.offer
        )
      end
      real_estate.pull_all(:channels, ['reference_projects'])
    end
  end

  def self.down
    ReferenceProject.delete_all
  end
end
