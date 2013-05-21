class ReferenceProject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  include Offer::Accessors

  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  embeds_many :images, :class_name => "ReferenceProjectImage", cascade_callbacks: true

  default_scope asc(:position)
  scope :for_rent, where(:offer => Offer::RENT)
  scope :for_sale, where(:offer => Offer::SALE)

  field :title,             :type => String
  field :description,       :type => String
  field :construction_info, :type => String
  field :utilization,       :type => String, :default => Utilization::LIVING
  field :offer,             :type => String, :default => Offer::RENT
  field :section,           :type => String
  field :url,               :type => String
  field :locale,            :type => String, :default => 'de'
  field :attachment,        :type => String
  field :position,          :type => Integer

  belongs_to :real_estate

  validates :title, :locale, :offer, :utilization, :section, :images, :presence => true
  validates_length_of :description, maximum: 500

  mount_uploader :attachment, ReferenceProjectAttachmentUploader
  mount_uploader :image, ReferenceProjectImageUploader

  before_create :setup_position

  # Section scopes
  scope :residential_buildings, :where => { :section =>  ReferenceProjectSection::RESIDENTIAL_BUILDING }
  scope :residential_commercial_buildings, :where => { :section =>  ReferenceProjectSection::RESIDENTIAL_BUILDING }
  scope :business_buildings, :where => { :section =>  ReferenceProjectSection::BUSINESS_BUILDING }
  scope :trade_industrial_buildings, :where => { :section =>  ReferenceProjectSection::TRADE_INDUSTRIAL_BUILDING }
  scope :special_buildings, :where => { :section =>  ReferenceProjectSection::SPECIAL_BUILDING }
  scope :rebuildings, :where => { :section =>  ReferenceProjectSection::REBUILDING }

  def for_sale?
    self.offer == RealEstate::OFFER_FOR_SALE
  end

  def for_rent?
    self.offer == RealEstate::OFFER_FOR_RENT
  end

  def slider_image
    self.images.first.image
  end

  private
  def setup_position
    self.position = ReferenceProject.max(:position) || 0 + 1
  end
end
