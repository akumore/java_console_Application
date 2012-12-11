class ReferenceProject
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope asc(:position)
  scope :for_rent, where(:offer => Offer::RENT)
  scope :for_sale, where(:offer => Offer::SALE)

  field :title,       :type => String
  field :description, :type => String
  field :utilization, :type => String, :default => Utilization::LIVING
  field :offer,       :type => String, :default => Offer::RENT
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
    self.offer == Offer::SALE
  end

  def for_rent?
    self.offer == Offer::RENT
  end

  private
  def setup_position
    self.position = ReferenceProject.max(:position) || 0 + 1
  end

end
