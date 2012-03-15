module Export
  module Homegate
    class Packager
      def package(real_estate)
        Homegate::RealEstatePackage.new(real_estate).save
      end

      def path
        time = Time.now
        File.join root_path, time.strftime("%Y_%m_%d"), time.strftime("%H_%M")
      end

      def root_path
        File.join Rails.root, 'tmp', 'export'
      end
    end
  end
end