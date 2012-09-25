require 'net/ftp'

module Export
  module Idx301
    class FtpUploader < Logger::Application
      include Logging

      attr_reader :packager, :config

      def initialize(packager, portal)
        super "#{portal} FTP Uploader"
        init_logging

        @portal   = portal
        @packager = packager
        @config   = Settings.idx301.send(portal).ftp
      end

      def do_upload!
        logger.info "Uploading files to #{@portal} account."
        connect! do
          files.each { |item| upload item }
        end
      end

      def files
        list = Dir.glob("#{local_base_dir}/**/**").sort
        list.delete_if { |elem| elem.include?('unload.txt') && !elem.include?("#{@portal}_unload.txt") }
      end

      private

      def upload(element)
        local_element = element
        remote_element = element.gsub(packager.path, @ftp.pwd)
        remote_element = remote_element.gsub("#{@portal}_unload.txt", 'unload.txt') if remote_element.include? 'unload.txt'

        logger.info "Uploading file '#{local_element}' to '#{remote_element}' on #{@portal}"

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

      def local_base_dir
        @packager.path
      end

      def connect!
        logger.info "FTP connect to #{@portal}"
        @ftp ||= Net::FTP.open(config[:host], config[:username], config[:password])
        @ftp.passive = true
        if block_given?
          yield self
          logger.info "FTP disconnect from #{@portal}"
          @ftp.close
        end
        @ftp
      end
    end
  end
end
