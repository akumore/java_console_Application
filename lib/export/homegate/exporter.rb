module Export
  module Homegate
    class Exporter < Export::Exporter::Base

      def initialize(dispatcher)
        @packager = Homegate::Packager.new
        @uploader = Homegate::Uploader.new(@packager.path, Settings.homegate.ftp)

        super(dispatcher)
      end

      def update(action, job)
        self.send(action, job) if respond_to?(action)
      end

      def add(job)
        @packager.package(job) if job.channels.include?(RealEstate::HOMEGATE_CHANNEL)
      end

      def finish
        @uploader.upload
      end

    end
  end
end
