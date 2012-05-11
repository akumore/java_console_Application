require 'net/ftp'

module Export
  module Homegate
    class FtpUploader < Logger::Application
      include Logging

      attr_reader :packager, :config

      def initialize(packager, config)
        super "Homegate FTP Uploader"
        init_logging

        @packager = packager
        @config = config
      end

      def do_upload!
        logger.info "Uploading files."
        connect! do
          files.each { |item| upload item }
        end
      end

      private

      def upload(element)
        local_element = element
        remote_element = element.gsub(packager.path, @ftp.pwd)

        logger.debug "Uploading file '#{local_element}' to '#{remote_element}'"

        if FileTest.directory?(local_element)
          # check to prevent '550 File exists' error
          #begin
          #  @ftp.nlst(remote_element).empty?
          #rescue Net::FTPPermError => err
          #  binding.pry
          #  if @ftp.last_response_code == 550
          #    @ftp.mkdir(remote_element)
          #  else
          #    raise err
          #  end
          #end
        else
          @ftp.put element, remote_element
        end
      end

      def files
        Dir.glob("#{local_base_dir}/**/**").sort
      end

      def local_base_dir
        @packager.path
      end

      def connect!
        logger.debug 'FTP connect'
        @ftp ||= Net::FTP.open(config[:host], config[:username], config[:password])
        @ftp.passive = true
        if block_given?
          yield self
          logger.debug "FTP disconnect"
          @ftp.close
        end
        @ftp
      end
    end
  end
end
