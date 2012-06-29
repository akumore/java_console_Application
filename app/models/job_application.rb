class JobApplication

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :job

  mount_uploader :attachment, JobApplicationUploader

  field :firstname, :type => String
  field :lastname, :type => String
  field :birthdate, :type => String
  field :street, :type => String
  field :city, :type => String
  field :zipcode, :type => String
  field :phone, :type => String
  field :mobile, :type => String
  field :email, :type => String
  field :attachment, :type => String
  field :comment, :type=>String

  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :birthdate, :presence => true
  validates :street, :presence => true
  validates :zipcode, :presence => true
  validates :city, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true
  validates :comment, :presence => true

  def unsolicited?
    job.nil?
  end

end
