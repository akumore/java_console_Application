CarrierWave.configure do |config|
  config.permissions = 0666
  config.storage = :file

  if Rails.env.test?
    config.enable_processing = false
  end
end


module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end
