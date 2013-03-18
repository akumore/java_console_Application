class AddExistingReferenceProjectImageToReferenceProjectImages < Mongoid::Migration
  def self.up
    total = ReferenceProject.all.count
    per_batch = 5

    0.step(total, per_batch) do |offset|
      ReferenceProject.limit(per_batch).skip(offset).each do |reference_project|
        if reference_project.image.present?
          photo = ReferenceProjectImage.create(:image => reference_project.image, :reference_project => reference_project)
          photo.write_uploader(:image, reference_project.image)
          photo.save!
          photo.image.recreate_versions!
        end
      end
    end
  end

  def self.down
    ReferenceProject.all.each do |reference_project|
      reference_project.images.destroy
      reference_project.save
    end
  end
end
