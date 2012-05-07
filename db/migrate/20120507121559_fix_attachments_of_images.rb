class FixAttachmentsOfImages < Mongoid::Migration

  def self.up
    real_estates = RealEstate.all.select { |r| r.images.any? }
    real_estates.each do |real_estate|
      new_images = []
      real_estate.images.each do |image|
        new_images << copy_asset(image)
      end

      new_images.each do |image|
        puts "Invalid image found for real estate #{real_estate.id}" unless image.valid?
        real_estate.images << image
      end
      puts "Copied #{new_images.size} images of real estate #{real_estate.id}"
    end

    #cleanup
    real_estates = RealEstate.all.select { |r| r.images.any? }
    real_estates.each do |real_estate|
      real_estate.images.each do |image|
        if image.created_at < (Time.now - 15.minutes)
          puts "Destroying image #{image.id}, title: #{image.title}, created_at: #{image.created_at} of real estate #{real_estate.id}"
          image.destroy
        end
      end
    end
  end

  def self.down
    raise Mongoid::IrreversibleMigration.new("Redoing this migration will remove all assets created_at < Time.now - 15.minutes")
  end

  private
  def self.copy_asset(asset)
    MediaAssets::Image.new extract_asset_params(asset)
  end

  def self.extract_asset_params(asset)
    [:title, :file, :is_primary, :position].inject({}) do |h, attr|
      h[attr] = asset.send(attr) if asset.respond_to?(attr)
      h
    end
  end


end