module Export
  module Idx301
    class RealEstatePackage < Logger::Application
      include Logging
      attr_accessor :packager

      def initialize(real_estate, packager, portal)
        super "#{portal.capitalize} RealEstate Package"
        init_logging

        @packager = packager
        @portal = portal
        @real_estate = real_estate
        @images = []
        @videos = []
        @documents = []
      end

      def package_assets
        @real_estate.images.each do |image|
          add_image(image.file.gallery)
        end

        @real_estate.floor_plans.each do |floor_plan|
          add_image(floor_plan.file.gallery)
        end

        @real_estate.videos.each do |video|
          add_video(video.file)
        end

        if @real_estate.has_handout?
          add_handout(@real_estate.handout)
        end

        @real_estate.documents.each do |document|
          add_document(document.file)
        end
      end

      def write
        logger.info "Writing writer.path for #{@portal}"
        writer.write Idx301::RealEstateDecorator.new(@real_estate, @portal, asset_paths).to_a
        true
      end

      def asset_paths
        { :images => @images, :documents => @documents, :videos => @videos }
      end

      def add_image(file)
        ext   = File.extname(file.path)
        path  = file.path
        filename = "i_#{@real_estate.id}_#{@images.length + 1}#{ext}"
        target_path = File.join(@packager.path, 'images', filename)
        FileUtils.cp(path, target_path)
        @images << filename
      end

      def add_video(file)
        ext = File.extname(file.path)
        filename = "v_#{@real_estate.id}_#{@videos.length + 1}#{ext}"
        target_path = File.join(@packager.path, 'movies', filename)
        FileUtils.cp(file.path, target_path)
        @videos << filename
      end

      def add_handout(handout)
        filename = "d_#{@real_estate.id}_#{@documents.length + 1}.pdf"
        target_path = File.join(@packager.path, 'doc', filename)
        if File.exists? handout.path
          logger.info "Adding cache file for handout #{handout.path}"
          FileUtils.cp(handout.path, target_path)
        else
          logger.info "Creating handout #{handout.path}"
          handout.to_file(target_path)
        end
        @documents << filename
      end

      def add_document(file)
        ext = File.extname(file.path)
        filename = "d_#{@real_estate.id}_#{@documents.length + 1}#{ext}"
        target_path = File.join(@packager.path, 'doc', filename)
        FileUtils.cp(file.path, target_path)
        @documents << filename
      end

      def save
        package_assets
        write
      end

      private
      def writer
        @writer ||= Idx301::CsvWriter.new(File.join(@packager.path, 'data', "#{@portal}_unload.txt"), 'ab')
      end

    end
  end
end
