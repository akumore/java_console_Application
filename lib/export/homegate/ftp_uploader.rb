require 'net/ftp'

module Export
  module Homegate
    class FtpUploader

      attr_reader :packager, :config

      def initialize(packager, config)
        @packager = packager
        @config = config
      end

      def do_upload!
        connect! do
          files.each { |item| upload item }
        end
      end

      private

      def upload(element)
        local_element = element
        remote_element = element.gsub(packager.path, @ftp.pwd)

        logger.info "Uploading file '#{local_element}' to '#{remote_element}'"

        if FileTest.directory?(local_element)
          # check to prevent '550 File exists' error
          begin
            @ftp.nlst(remote_element).empty?
          rescue
            if @ftp.last_response_code == 550
              @ftp.mkdir(remote_element)
            end
          end
        else
          @ftp.put element, remote_element
        end
      end

      def files
        Dir.glob("#{local_base_dir}/**/**").sort
      end

      def logger
        Rails.logger
      end

      def local_base_dir
        @packager.path
      end

      def connect!
        logger.info 'FTP connect'
        @ftp ||= Net::FTP.open(config[:host], config[:username], config[:password])
        if block_given?
          yield self
          logger.info "FTP disconnect"
          @ftp.close
        end
        @ftp
      end
    end
  end
end
