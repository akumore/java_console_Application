class Office
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :real_estates

  field :label, :type => String
  field :name, :type => String
  field :company_label, :type => String # Alfred Müller SA
  field :zip, :type => String
  field :city, :type => String
  field :street, :type => String
  field :phone, :type => String
  field :fax, :type => String
  field :language, :type => String, :default => I18n.locale

  validates :label, :presence => true
  validates :name, :presence => true
end
