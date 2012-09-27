require 'net/ftp'

module Export
  module Idx301
    class FtpUploader < Logger::Application
      include Logging

      attr_reader :packager, :config

      def initialize(packager, target)
        super "#{target.name} FTP Uploader"
        init_logging

        @target   = target
        @packager = packager
      end

      def do_upload!
        logger.info "Uploading files to #{@target.name} account."
        connect! do
          files.each { |item| upload item }
        end
      end

      def files
        list = Dir.glob("#{local_base_dir}/**/**").sort
      end

      private

      def upload(element)
        local_element = element
        remote_element = element.gsub(packager.path, @ftp.pwd)

        logger.info "Uploading file '#{local_element}' to '#{remote_element}' on #{@target.name}"

        if FileTest.directory?(local_element)
          # check to prevent '550 File exists' error
        else
          @ftp.put element, remote_element
        end
      end

      def local_base_dir
        @packager.path
      end

      def connect!
        logger.info "FTP connect to #{@target.name}"
        @ftp ||= Net::FTP.open(target.config[:host], target.config[:username], target.config[:password])
        @ftp.passive = true
        if block_given?
          yield self
          logger.info "FTP disconnect from #{@target.name}"
          @ftp.close
        end
        @ftp
      end
    end
  end
end
