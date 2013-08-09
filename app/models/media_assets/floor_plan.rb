module MediaAssets
  class FloorPlan < ImageBase
    mount_uploader :file, MediaAssets::FloorPlanUploader

    private
    def setup_position
      self.position ||= real_estate.floor_plans.max(:position).to_i + 1
    end
  end
end
