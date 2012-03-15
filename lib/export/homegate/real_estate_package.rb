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
        @real_estate.media_assets.images.each do |image|
          add_image(image.path)
        end

        @real_estate.media_assets.videos.each do |video|
          add_video(video.path)
        end

        @real_estate.media_assets.documents.each do |document|
          add_document(document.path)
        end
      end

      def write
        #Homegate::Decorator.new(@real_estate, assets)
        true
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

      def sanitize_path(path)
        path
      end

      def convert_image(path)
        path = sanitize_path(path)
        path
      end

      def save
        package_assets
        write
      end

    end
  end
end