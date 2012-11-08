class Account
  include ActiveModel::Validations

  attr_accessor :provider # Provider model constants
  attr_accessor :agency_id
  attr_accessor :sender_id # should never change once in use
  attr_accessor :video_support # does provider support video?
  attr_accessor :offices # an array of office names

  # ftp config
  attr_accessor :username
  attr_accessor :password
  attr_accessor :host

  validates :provider, :presence => true
  validates :agency_id, :presence => true
  validates :sender_id, :presence => true
  validates :username, :presence => true
  validates :password, :presence => true
  validates :host, :presence => true

  def initialize(data = {})
    data.each do |key, value|
      send "#{key}=", value if respond_to? "#{key}="
    end
  end

  def offices
    Office.where(:name => @offices)
  end

  def real_estates
    RealEstate.where(:office_id.in => offices.map(&:id))
  end

  def video_support?
    video_support
  end

  def name
    provider
  end

  def self.all
    Settings.idx301.map do |data|
      Account.new data
    end
  end

end
