class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :real_estate

  field :firstname, :type => String
  field :lastname, :type => String
  field :email, :type => String
  field :phone, :type => String
  field :street, :type => String
  field :zipcode, :type => String
  field :city, :type => String

  validates :firstname, :lastname, :email, :street, :zipcode, :city, :presence => true

end
