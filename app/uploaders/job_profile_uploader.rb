# encoding: utf-8
require 'carrierwave/processing/mime_types'

class JobProfileUploader < BaseUploader

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(pdf)
  end
end
