module Export
  module Idx301
    class Exporter < Logger::Application
      include Logging

      attr_accessor :packager
      attr_accessor :uploader

      def initialize(account)
        super "Initializing and preparing export for #{account.name}..."
        init_logging

        @account   = account
        @packager = Idx301::Packager.packager_class_for_provider(account.provider).new(account)
        @uploader = Idx301::FtpUploader.new(@packager, account)
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

      def upload
        begin
          @uploader.do_upload!
          logger.info "Published #{@packages.size} real estates on #{@account.name}."
        rescue => err
          logger.warn "#{err.class} raised on action 'upload', exception message was:\n#{err.message}"
          logger.info err.backtrace.join("\n")
          Airbrake.notify(err)
        end
      end
    end
  end
end
