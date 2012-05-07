class FixAttachmentsOfVideos < Mongoid::Migration
  def self.up
    real_estates = RealEstate.all.select {|r| r.videos.any?}
    real_estates.each do |real_estate|
      new_video s = []
      real_estate.videos.each do |video|
        new_videos << copy_asset(video)
      end

      new_videos.each do |video|
        puts "Invalid video found for real estate #{real_estate.id}" unless video.valid?
        real_estate.videos << video
      end
      puts "Copied #{new_videos.size} videos of real estate #{real_estate.id}"
    end

    #cleanup
    real_estates = RealEstate.all.select {|r| r.videos.any?}
    real_estates.each do |real_estate|
      real_estate.videos.each do |video|
        if video.created_at < (Time.now - 5.minutes)
          puts "Destroying video #{video.id}, title: #{video.title}, created_at: #{video.created_at} of real estate #{real_estate.id}"
          video.destroy
        end
      end
    end
  end

  def self.down
    raise Mongoid::IrreversibleMigration.new("Redoing this migration will remove all assets created_at < Time.now - 5.minutes")
  end
  
  
  private
  def self.copy_asset(asset)
    MediaAssets::Video.new extract_asset_params(asset)
  end

  def self.extract_asset_params(asset)
    [:title, :file, :is_primary, :position].inject({}) do |h, attr|
      h[attr] = asset.send(attr) if asset.respond_to?(attr)
      h
    end
  end
  
end