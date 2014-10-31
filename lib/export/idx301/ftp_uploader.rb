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
          error_count = 0
          files.each do |item|
            begin
              upload item
            rescue => exception
              Airbrake.notify(exception)
              error_count +=1
              if error_count >= 10
                raise 'max error count reached'
              end
            end
          end
        end
      end

      def files
        Dir.glob("#{local_base_dir}/**/**").sort
      end

      private

      def upload(element)
        local_element = element
        remote_element = element.gsub(packager.path, @ftp.pwd)

        logger.info "Uploading file '#{local_element}' to '#{remote_element}' on #{@account.name}"

        # check to prevent '550 File exists' error
        return if FileTest.directory?(local_element)
        begin
          @ftp.put element, remote_element
        rescue Errno::ETIMEDOUT
          logger.warn "Uploading file '#{local_element}' to '#{remote_element}' on #{@account.name} timeout received (retry)"
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
        return @ftp unless block_given?
        begin
          yield self
        ensure
          logger.info "FTP disconnect from #{@account.name}"
          @ftp.close
        end
      end
    end
  end
end
