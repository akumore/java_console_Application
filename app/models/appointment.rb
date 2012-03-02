class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :real_estate

  field :firstname, :type => String
  field :lastname, :type => String
  field :email, :type => String
  field :phone, :type => String

  validates :firstname, :lastname, :email, :phone, :presence=>true

end