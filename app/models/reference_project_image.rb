class ReferenceProjectImage
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :reference_project, :inverse_of => :images
  default_scope asc(:position)

  mount_uploader :image, ReferenceProjectImageUploader

  field :image, :type => String
  field :position, :type => Integer

  before_create :setup_position

  private
  def setup_position
    if reference_project.images
      self.position = reference_project.images.max(:position) + 1
    end
  end
end
