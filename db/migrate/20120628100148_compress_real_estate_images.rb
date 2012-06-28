class CompressRealEstateImages < Mongoid::Migration
  def self.up
    total = RealEstate.all.count
    per_batch = 5

    0.step(total, per_batch) do |offset|
      RealEstate.limit(per_batch).skip(offset).each do |real_estate|
        real_estate.images.each { |image| image.file.recreate_versions! if image.file.present? }
      end
    end
  end

  def self.down
  end
end
