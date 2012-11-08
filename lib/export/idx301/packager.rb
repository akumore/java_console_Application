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

      def self.packager_class_for_provider provider
        if provider == 'immoscout24'
          Export::Idx301::ImmoscoutPackager
        else
          Export::Idx301::Packager
        end
      end

      def package(real_estate)
        logger.info "Packaging."
        Idx301::RealEstatePackage.new(real_estate, self, @target).save(unload_file)
      end

      def unload_file
        File.join(self.data_path, 'unload.txt')
      end

      def path
        @path ||= File.join root_path, @date_folder, @time_folder, @target.name
      end

      def doc_path
        File.join self.path, 'doc'
      end

      def data_path
        File.join self.path, 'data'
      end

      def image_path
        File.join self.path, 'images'
      end

      def movie_path
        File.join self.path, 'movies'
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end

      private

      def create_folders
        logger.info "Creating folder structure for #{@target.name}"
        FileUtils.mkdir_p path
        FileUtils.mkdir_p self.data_path
        FileUtils.mkdir_p self.image_path
        FileUtils.mkdir_p self.movie_path
        FileUtils.mkdir_p self.doc_path
      end

    end
  end
end
