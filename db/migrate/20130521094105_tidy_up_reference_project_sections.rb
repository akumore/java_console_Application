class TidyUpReferenceProjectSections < Mongoid::Migration
  def self.up
    to_be_renamed_reference_project_section = ReferenceProject.where(:section => 'residetal_building')
    to_be_removed_reference_project_section = ReferenceProject.where(:section => 'public_building')

    to_be_renamed_reference_project_section.each do |reference_project|
      reference_project.update_attribute(:section, 'residential_building')
    end

    to_be_removed_reference_project_section.each do |reference_project|
      reference_project.update_attribute(:section, '')
    end
  end

  def self.down
  end
end
