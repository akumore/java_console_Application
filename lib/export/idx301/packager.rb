module Export
  module Idx301
    class Packager < Logger::Application
      include Logging

      def initialize
        super "Homegate Packager"
        init_logging

        @time = Time.now
        @date_folder = @time.strftime("%Y_%m_%d")
        @time_folder = @time.strftime("%H_%M")
        create_folders
      end

      def package(real_estate)
        logger.debug "Packaging."
        Idx301::RealEstatePackage.new(real_estate, self).save
      end

      def path
        @path ||= File.join root_path, @date_folder, @time_folder
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end

      private
      def create_folders
        logger.debug "Creating Homegates folder structure"
        FileUtils.mkdir_p path
        FileUtils.mkdir_p File.join(path, 'data')
        FileUtils.mkdir_p File.join(path, 'images')
        FileUtils.mkdir_p File.join(path, 'movies')
        FileUtils.mkdir_p File.join(path, 'doc')
      end

    end
  end
end
