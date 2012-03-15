module Export
  module Homegate
    class Packager
      def initialize
        @time = Time.now
        @date_folder = @time.strftime("%Y_%m_%d")
        @time_folder = @time.strftime("%H_%M")
      end

      def package(real_estate)
        Homegate::RealEstatePackage.new(real_estate).save
      end

      def path
        File.join root_path, @date_folder, @time_folder
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end
    end
  end
end