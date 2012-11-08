class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  # given that we have a single account for all offices,
  # we need to have a n-n relation
  has_and_belongs_to_many :offices

  field :provider, :type => String # => Provider model constants
  field :agency_id, :type => String
  field :sender_id, :type => String # should never change once in use
  field :video_support, :type => Boolean, :default => true # does provider support video?

  # ftp config
  field :username, :type => String
  field :password, :type => String
  field :host, :type => String

  validates :provider, :presence => true
  validates :agency_id, :presence => true
  validates :sender_id, :presence => true
  validates :username, :presence => true
  validates :password, :presence => true
  validates :host, :presence => true

end
