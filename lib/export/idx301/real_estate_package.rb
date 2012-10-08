module Export
  module Idx301
    class RealEstatePackage < Logger::Application
      include Logging
      attr_accessor :packager

      def initialize(real_estate, packager, target)
        super "#{target.name} RealEstate Package"
        init_logging

        @packager = packager
        @target = target
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

        if @target.video_support?
          @real_estate.videos.each do |video|
            add_video(video.file)
          end
        end

        if @real_estate.has_handout?
          add_handout(@real_estate.handout)
        end

        @real_estate.documents.each do |document|
          add_document(document.file)
        end
      end

      def asset_paths
        { :images => @images, :documents => @documents, :videos => @videos }
      end

      def add_image(file)
        ext   = File.extname(file.path)
        path  = file.path
        filename = "i_#{@real_estate.id}_#{@images.length + 1}#{ext}"
        target_path = File.join(@packager.image_path, filename)
        FileUtils.cp(path, target_path)
        @images << filename
      end

      def add_video(file)
        ext = File.extname(file.path)
        filename = "v_#{@real_estate.id}_#{@videos.length + 1}#{ext}"
        target_path = File.join(@packager.movie_path, filename)
        FileUtils.cp(file.path, target_path)
        @videos << filename
      end

      def add_handout(handout)
        filename = "d_#{@real_estate.id}_#{@documents.length + 1}.pdf"
        target_path = File.join(@packager.doc_path, filename)
        handout_path = File.join Rails.root, 'public', handout.path
        if File.exists? handout_path
          logger.info "Adding cache file for handout #{handout.path}"
          FileUtils.cp(handout_path, target_path)
        else
          logger.info "Creating handout #{handout.path}"
          handout.to_file(target_path)
        end
        @documents << filename
      end

      def add_document(file)
        ext = File.extname(file.path)
        filename = "d_#{@real_estate.id}_#{@documents.length + 1}#{ext}"
        target_path = File.join(@packager.doc_path, filename)
        FileUtils.cp(file.path, target_path)
        @documents << filename
      end

      def save(unload_file)
        package_assets
        logger.info "Writing unload.txt for #{@target.name}"
        writer(unload_file).write Idx301::RealEstateDecorator.new(@real_estate, @target, asset_paths).to_a
      end

      private

      def writer(path)
        @writer ||= Idx301::CsvWriter.new(path, 'ab')
      end

    end
  end
end