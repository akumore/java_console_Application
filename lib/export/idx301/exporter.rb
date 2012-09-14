module Export
  module Idx301
    class Exporter < Logger::Application
      include Logging

      attr_accessor :packager
      attr_accessor :uploader

      def initialize(portal)
        super "Initializing and preparing export for #{portal}..."
        init_logging

        @portal   = portal
        @packager = Idx301::Packager.new(portal)
        @uploader = Idx301::FtpUploader.new(@packager, portal)
        @packages = []
      end

      def add(real_estate)
        begin
          if real_estate.channels.include?(RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL)
            logger.info "Exporting real estate #{real_estate.id}"
            @packages << @packager.package(real_estate)
          end
        rescue => err
          logger.warn "#{err.class} raised on action 'add', exception message was:\n#{err.message}"
          logger.info err.backtrace.join("\n")
        end
      end

      def finish
        begin
          @uploader.do_upload!
          logger.info "Published #{@packages.size} real estates on #{@portal}."
        rescue => err
          logger.warn "#{err.class} raised on action 'finish', exception message was:\n#{err.message}"
          logger.info err.backtrace.join("\n")
        end
      end

    end
  end
end
