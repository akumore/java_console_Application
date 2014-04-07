CarrierWave.configure do |config|
  config.permissions = 0666
  config.storage = :file

  if Rails.env.test?
    config.enable_processing = false
  end
end


module CarrierWave
  module MiniMagick

    def quality(percentage)
      manipulate! do |img|
        img.strip! # removes profiles and comments, saves about 90% on thumbnails
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end
