class Contact
  
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :street, :type => String
  field :zip, :type => String
  field :city, :type => String
  field :email, :type => String
  field :message, :type => String

  validates :name, :street, :zip, :city, :email, :message, :presence => true
end
