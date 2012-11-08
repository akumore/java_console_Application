require 'net/ftp'

module Export
  module Idx301
    class FtpUploader < Logger::Application
      include Logging

      attr_reader :packager, :config

      def initialize(packager, account)
        super "#{account.name} FTP Uploader"
        init_logging

        @account  = account
        @packager = packager
      end

      def do_upload!
        logger.info "Uploading files to #{@account.name} account."
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

        logger.info "Uploading file '#{local_element}' to '#{remote_element}' on #{@account.name}"

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
        logger.info "FTP connect to #{@account.name}"
        @ftp ||= Net::FTP.open(@account.host, @account.username, @account.password)
        @ftp.passive = true
        if block_given?
          yield self
          logger.info "FTP disconnect from #{@account.name}"
          @ftp.close
        end
        @ftp
      end
    end
  end
end
