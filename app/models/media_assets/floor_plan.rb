module MediaAssets
  class FloorPlan
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :real_estate

    mount_uploader :file, MediaAssets::FloorPlanUploader

    field :title, :type => String
    field :file, :type => String

    validates :title, :presence => true
    validates_presence_of :file, :if => :new_record?

  end
end
