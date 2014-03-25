class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :job_profile_file, JobProfileUploader

  field :title, type: String
  field :text, type: String
  field :is_published, type: Boolean
  field :job_profile_file, type: String
  field :locale, type: String, default: :de
  field :position, type: Integer

  default_scope asc(:position)
  scope :published, where(is_published: true)

  validates :title, presence: true

  before_create :initialize_position

  private
  def initialize_position
    self.position = Job.max(:position).to_i + 1
  end
end
