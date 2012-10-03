class ReferenceProject
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope asc(:position)
  scope :for_rent, where(:offer => RealEstate::OFFER_FOR_RENT)
  scope :for_sale, where(:offer => RealEstate::OFFER_FOR_SALE)

  field :title,       :type => String
  field :description, :type => String
  field :utilization, :type => String, :default => RealEstate::UTILIZATION_PRIVATE
  field :offer,       :type => String, :default => RealEstate::OFFER_FOR_RENT
  field :url,         :type => String
  field :locale,      :type => String, :default => 'de'
  field :image,       :type => String
  field :position,    :type => Integer

  belongs_to :real_estate

  validates :title, :locale, :offer, :utilization, :image, :presence => true
  validates_length_of :description, maximum: 500

  mount_uploader :image, ReferenceProjectImageUploader

  before_create :setup_position

  def for_sale?
    self.offer == RealEstate::OFFER_FOR_SALE
  end

  def for_rent?
    self.offer == RealEstate::OFFER_FOR_RENT
  end

  private
  def setup_position
    self.position = ReferenceProject.max(:position) || 0 + 1
  end

end
