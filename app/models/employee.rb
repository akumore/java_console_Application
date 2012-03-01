class Employee
  include Mongoid::Document
  include Mongoid::Timestamps

  MARKETING_DEPARTMENT = "marketing"
  REAL_ESTATE_MANAGEMENT_DEPARTMENT = "real_estate_management"
  DEPARTMENTS = [MARKETING_DEPARTMENT, REAL_ESTATE_MANAGEMENT_DEPARTMENT]

  mount_uploader :image, EmployeeImageUploader

  has_many :real_estates, :as=>:contact

  field :firstname, :type => String
  field :lastname, :type => String
  field :phone, :type => String
  field :mobile, :type => String
  field :fax, :type => String
  field :image, :type => String
  field :email, :type => String
  field :job_function, :type => String
  field :department, :type => String

  validates :firstname, :lastname, :phone, :email, :department, :presence => true

  def fullname
    [firstname, lastname].join ' '
  end

  def fullname_reversed
    [lastname, firstname].join ', '
  end
end
