class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :text, :type => String
  field :is_published, :type => Boolean
  field :job_profile_file, :type => String

  mount_uploader :job_profile_file, JobProfileUploader

  validates :title, :presence => true
  validates :text, :presence => true
end
