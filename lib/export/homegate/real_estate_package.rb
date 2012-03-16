module Export
  module Homegate
    class RealEstatePackage
      
      attr_accessor :packager

      def initialize(real_estate, packager)
        @packager = packager
        @real_estate = real_estate
        @images = []
        @videos = []
        @documents = []
      end

      def package_assets
        @real_estate.media_assets.images.each do |image|
          add_image(image.file)
        end

        @real_estate.media_assets.videos.each do |video|
          add_video(video.file)
        end

        @real_estate.media_assets.docs.each do |document|
          add_document(document.file)
        end
      end

      def write
        #Homegate::Decorator.new(@real_estate, assets)
        writer.write %w(HERE GOES THE FIELDS. TEST#TEST TEST###TEST)
        true
      end

      def asset_paths
        { :images => @images, :documents => @documents, :videos => @videos }
      end

      def add_image(file)
        ext   = File.extname(file.path)
        path  = file.path
        
        unless ['.jpeg', '.jpg'].include? ext
          path  = file.jpeg_format.path
          ext   = File.extname(path)
        end

        filename = "i_#{@real_estate.id}_#{asset_paths[:images].length + 1}#{ext}"
        target_path = File.join(@packager.path, 'images', filename)
        FileUtils.cp(path, target_path)
        @images << filename
      end

      def add_video(file)
        ext = File.extname(file.path)
        filename = "v_#{@real_estate.id}_#{asset_paths[:videos].length + 1}#{ext}"
        target_path = File.join(@packager.path, 'movies', filename)
        FileUtils.cp(file.path, target_path)
        @videos << filename
      end

      def add_document(file)
        ext = File.extname(file.path)
        filename = "d_#{@real_estate.id}_#{asset_paths[:documents].length + 1}#{ext}"
        target_path = File.join(@packager.path, 'documents', filename)
        FileUtils.cp(file.path, target_path)
        @documents << filename
      end

      def save
        package_assets
        write
      end


      private
      def writer
        @writer ||= CsvWriter.new(File.join(@packager.path, 'data', 'unload.txt'), 'ab')
      end

    end
  end
end