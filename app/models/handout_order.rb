class HandoutOrder
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::SpamProtection

  field :company,   :type => String
  field :firstname, :type => String
  field :lastname,  :type => String
  field :email,     :type => String
  field :phone,     :type => String
  field :street,    :type => String
  field :zipcode,   :type => String
  field :city,      :type => String

  validates :firstname,
            :lastname,
            :email,
            :phone,
            :street,
            :zipcode,
            :city,
            :presence => true
end
