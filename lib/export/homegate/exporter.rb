module Export
  module Homegate
    class Exporter < Export::Exporter::Base

      attr_accessor :packager
      attr_accessor :uploader

      def initialize(dispatcher)
        super(dispatcher, "Homegate Export")

        logger.info "Initializing and preparing..."
        @packager = Homegate::Packager.new
        @uploader = Homegate::FtpUploader.new(@packager, Settings.idx301.homegate.ftp)
        @packages = []
      end

      def update(*args)
        action = args.shift

        begin
          self.send(action, *args) if respond_to?(action)
        rescue => err
          logger.warn "#{err.class} raised on action '#{action}', exception message was:\n#{err.message}"
          logger.debug err.backtrace.join("\n")
        end
      end

      def add(real_estate)
        if real_estate.channels.include?(RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL)
          logger.debug "Exporting real estate #{real_estate.id}"
          @packages << @packager.package(real_estate)
        end
      end

      def finish
        @uploader.do_upload!
        logger.info "Published #{@packages.size} real estates on Homegate."
      end

    end
  end
end
