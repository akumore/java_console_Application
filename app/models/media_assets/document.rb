module MediaAssets
  class Document < Base
    mount_uploader :file, MediaAssets::DocumentUploader


    private
    def setup_position
      self.position ||= real_estate.documents.max(:position).to_i + 1
    end
  end
end
