module Export
  module Homegate
    class Packager

      def initialize
        @time = Time.now
        @date_folder = @time.strftime("%Y_%m_%d")
        @time_folder = @time.strftime("%H_%M")
        create_folders
      end

      def package(real_estate)
        Homegate::RealEstatePackage.new(real_estate, self).save
      end

      def path
        File.join root_path, @date_folder, @time_folder
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end

      private
      def create_folders
        FileUtils.mkdir_p path
        FileUtils.mkdir_p File.join(path, 'data')
        FileUtils.mkdir_p File.join(path, 'images')
        FileUtils.mkdir_p File.join(path, 'movies')
        FileUtils.mkdir_p File.join(path, 'doc')
      end

    end
  end
end