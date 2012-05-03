module Export
  module Homegate
    class Exporter < Export::Exporter::Base

      attr_accessor :packager
      attr_accessor :uploader

      def initialize(dispatcher)
        @packager = Homegate::Packager.new
        @uploader = Homegate::FtpUploader.new(@packager, Settings.homegate.ftp)
        @packages = []

        super(dispatcher)
      end

      def update(*args)
        action = args.shift
        self.send(action, *args) if respond_to?(action)
      end

      def add(real_estate)
        @packages << @packager.package(real_estate) if real_estate.channels.include?(RealEstate::HOMEGATE_CHANNEL)
      end

      def finish
        @uploader.do_upload!
      end

    end
  end
end
