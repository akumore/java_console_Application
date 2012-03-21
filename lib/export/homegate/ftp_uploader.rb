require 'net/ftp'

module Export
  module Homegate
    class FtpUploader

      #attr_reader :packager, :ftp, :config
      #
      #HOST = 'url_to_ftp'
      #USERNAME = ''
      #PASSWORD = ''
      #
      #def initialize(packager)
      #  @packager = packager
      #  @ftp = Net::FTP.new
      #  @config ={
      #      :host => HOST,
      #      :user => USERNAME,
      #      :password => PASSWORD
      #  }
      #end
      #
      #def do_upload!
      #  connect! do
      #    files.each { |item| upload item }
      #  end
      #end
      #
      #
      #private
      #def upload(element)
      #  local_element = element
      #  remote_element = element.gsub(packager.path, ftp.pwd)
      #
      #  logger.info "Uploading file '#{local_element}' to '#{remote_element}'"
      #
      #  if FileTest.directory?(local_element)
      #    ftp.mkdir(remote_element)
      #  else
      #    ftp.put element, remote_element
      #  end
      #end
      #
      #def files
      #  Dir.glob("#{local_base_dir}/**/**").sort
      #end
      #
      #
      #def logger
      #  Rails.logger
      #end
      #
      #
      #def connect!
      #  logger.info 'FTP connect'
      #  ftp ||= Net::FTP.open(config[:host], config[:user], config[:password])
      #  ftp.passive = config[:passive]
      #  if block_given?
      #    yield self
      #    logger.info "FTP disconnect"
      #    ftp.close
      #  end
      #  ftp
      #end

    end
  end
end
