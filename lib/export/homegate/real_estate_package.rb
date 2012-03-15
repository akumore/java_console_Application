module Export
  module Homegate
    class RealEstatePackage

      def initialize(real_estate)
        @real_estate = real_estate
        @images = []
        @movies = []
        @documents = []
      end

      def package_assets
        #@real_estate.media_assets.images.primary_first_sort.each do |image|
        #  add_image(image)
        #end

        # ... documents, videos
      end

      def write
        #Homegate::Decorator.new(@real_estate, assets)
      end

      def asset_paths
        { :images => @images, :documents => @documents, :movies => @movies }
      end

      def add_image(path)
        @images << convert_image(path)
      end

      def add_movie(path)
        @movies << path
      end

      def add_document(path)
        @documents << path
      end

      def save
        package_assets
        write
        true
      end

      private

      def convert_image(path)
        path
      end

    end
  end
end