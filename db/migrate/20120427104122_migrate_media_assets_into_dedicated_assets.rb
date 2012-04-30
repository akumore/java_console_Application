class MigrateMediaAssetsIntoDedicatedAssets < Mongoid::Migration
  def self.up
    real_estates = RealEstate.all.select { |r| r.media_assets.any? }

    real_estates.each do |real_estate|
      floor_plans = real_estate.media_assets.floorplans
      images = real_estate.media_assets.images.reject { |img| img.is_floorplan? }
      videos = real_estate.media_assets.videos
      docs = real_estate.media_assets.docs

      floor_plans.each do |floor_plan|
        with_rescue_from_file_not_found do
          real_estate.floor_plans << MediaAssets::FloorPlan.new(:title => floor_plan.title, :file => get_file_handle(floor_plan))
        end
      end

      images.each do |img|
        with_rescue_from_file_not_found do
          real_estate.images << MediaAssets::Image.new(:title => img.title, :is_primary => img.is_primary?, :file => get_file_handle(img))
        end
      end

      videos.each do |video|
        with_rescue_from_file_not_found do
          real_estate.images << MediaAssets::Video.new(:title => video.title, :file => get_file_handle(video))
        end
      end

      docs.each do |document|
        with_rescue_from_file_not_found do
          real_estate.documents << MediaAssets::Document.new(:title => document.title, :file => get_file_handle(document))
        end
      end
    end
  end


  def self.down
    real_estates = RealEstate.all.select { |r| r.media_assets.any? }

    real_estates.each do |real_estate|
      real_estate.images.destroy_all
      real_estate.floor_plans.destroy_all
      real_estate.videos.destroy_all
      real_estate.documents.destroy_all
    end
  end


  private
  def self.get_file_handle(resource)
    File.open File.join(Rails.public_path, resource.file.to_s)
  end

  def self.with_rescue_from_file_not_found
    begin
      yield
    rescue Errno::ENOENT => err
      Logger.new(STDOUT).warn [err.message, '...skipping!'].join(" ")
    end
  end

end