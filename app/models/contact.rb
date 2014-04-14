class Contact

  include Mongoid::Document
  include Mongoid::Timestamps

  field :firstname, :type => String
  field :lastname, :type => String
  field :street, :type => String
  field :zip, :type => String
  field :city, :type => String
  field :email, :type => String
  field :message, :type => String

  validates :firstname, :lastname, :street, :zip, :city, :email, :message, :presence => true

  # field that must be empty to protect from spam
  field :unnecessary_field, :type => String
  validates :unnecessary_field, inclusion: {in: ['']}
end
