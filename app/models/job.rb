class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :job_profile_file, JobProfileUploader

  field :title, :type => String
  field :text, :type => String
  field :is_published, :type => Boolean
  field :job_profile_file, :type => String

  scope :published, where(:is_published => true)

  validates :title, :presence => true
  validates :text, :presence => true
end
