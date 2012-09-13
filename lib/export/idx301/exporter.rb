module Export
  module Idx301
    class Exporter < Export::Exporter::Base

      attr_accessor :packager
      attr_accessor :uploader

      def initialize(dispatcher, portal)
        super(dispatcher, "#{portal.capitalize} Export")

        logger.info "Initializing and preparing for #{portal}..."
        @portal   = portal
        @packager = Idx301::Packager.new(portal)
        @uploader = Idx301::FtpUploader.new(@packager, portal)
        @packages = []
      end

      def update(*args)
        action = args.shift

        begin
          self.send(action, *args) if respond_to?(action)
        rescue => err
          logger.warn "#{err.class} raised on action '#{action}', exception message was:\n#{err.message}"
          logger.info err.backtrace.join("\n")
        end
      end

      def add(real_estate)
        if real_estate.channels.include?(RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL)
          logger.info "Exporting real estate #{real_estate.id}"
          @packages << @packager.package(real_estate)
        end
      end

      def finish
        @uploader.do_upload!
        logger.info "Published #{@packages.size} real estates on #{@portal}."
      end

    end
  end
end
