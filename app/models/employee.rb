class Employee
  include Mongoid::Document
  include Mongoid::Timestamps

  MARKETING_DEPARTMENT = "marketing"
  REAL_ESTATE_MANAGEMENT_DEPARTMENT = "real_estate_management"
  DEPARTMENTS = [MARKETING_DEPARTMENT, REAL_ESTATE_MANAGEMENT_DEPARTMENT]

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
  validates :phone, :mobile, :fax, :numericality => true, :allow_blank => true
end
