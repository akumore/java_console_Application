module Export
  module Idx301
    class Packager < Logger::Application
      include Logging

      def initialize(target)
        super "#{target.name} Packager"
        init_logging

        @time = Time.now
        @date_folder = @time.strftime("%Y_%m_%d")
        @time_folder = @time.strftime("%H_%M")
        @target = target
        create_folders
      end

      def package(real_estate)
        logger.info "Packaging."
        file = File.join(path, 'data', 'unload.txt')
        Idx301::RealEstatePackage.new(real_estate, self, @target).save(file)
      end

      def path
        @path ||= File.join root_path, @date_folder, @time_folder, @target.name
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end

      private
      def create_folders
        logger.info "Creating external real estate portal folder structure"
        FileUtils.mkdir_p path
        FileUtils.mkdir_p File.join(path, 'data')
        FileUtils.mkdir_p File.join(path, 'images')
        FileUtils.mkdir_p File.join(path, 'movies')
        FileUtils.mkdir_p File.join(path, 'doc')
      end

    end
  end
end
