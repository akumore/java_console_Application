class ReferenceProject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  include Offer::Accessors

  HOME_AND_OFFER_PAGE = 'home_offer_page'
  REFERENCE_PROJECT_PAGE = 'reference_project_page'
  DISPLAYED_ON_PAGES = [HOME_AND_OFFER_PAGE, REFERENCE_PROJECT_PAGE]

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
  field :displayed_on,      :type => Array

  belongs_to :real_estate

  validates :title,
            :locale,
            :images,
            :presence => true

  validates_length_of :description,
                      :maximum => 500

  validates :offer,
            :utilization,
            :presence => true,
            :if => :displayed_on_home_and_offer_page?

  validates :section,
            :presence => true,
            :if => :displayed_on_reference_project_page?

  mount_uploader :attachment, ReferenceProjectAttachmentUploader
  mount_uploader :image, ReferenceProjectImageUploader

  after_initialize :init_displayed_on_pages
  before_create :setup_position

  #
  # Section scopes
  #
  scope :residential_buildings, :where => { :section =>  ReferenceProjectSection::RESIDENTIAL_BUILDING }
  scope :residential_commercial_buildings, :where => { :section =>  ReferenceProjectSection::RESIDENTIAL_COMMERCIAL_BUILDING }
  scope :business_buildings, :where => { :section =>  ReferenceProjectSection::BUSINESS_BUILDING }
  scope :trade_industrial_buildings, :where => { :section =>  ReferenceProjectSection::TRADE_INDUSTRIAL_BUILDING }
  scope :special_buildings, :where => { :section =>  ReferenceProjectSection::SPECIAL_BUILDING }
  scope :rebuildings, :where => { :section =>  ReferenceProjectSection::REBUILDING }

  #
  # Displayed on scopes
  #
  scope :displayed_on_home_and_offer_page, :where => { :displayed_on => HOME_AND_OFFER_PAGE }
  scope :displayed_on_reference_project_page, :where => { :displayed_on => REFERENCE_PROJECT_PAGE }

  def for_sale?
    self.offer == RealEstate::OFFER_FOR_SALE
  end

  def for_rent?
    self.offer == RealEstate::OFFER_FOR_RENT
  end

  def slider_image
    self.images.first.image
  end

  def displayed_on_home_and_offer_page?
    self.displayed_on.include?(HOME_AND_OFFER_PAGE)
  end

  def displayed_on_reference_project_page?
    self.displayed_on.include?(REFERENCE_PROJECT_PAGE)
  end

  private
  def setup_position
    self.position = ReferenceProject.max(:position) || 0 + 1
  end

  def init_displayed_on_pages
    self.displayed_on ||= []
  end
end
