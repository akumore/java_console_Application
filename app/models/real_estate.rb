require 'copy_real_estate'

class RealEstate
  include Offer::Accessors
  include Utilization::Accessors

  include Mongoid::Document
  include Mongoid::Timestamps
  extend CopyRealEstate

  BUILDING_CORNER_HOUSE = 'corner_house'
  BUILDING_MIDDLE_HOUSE = 'middle_house'

  STATE_EDITING = 'editing'
  STATE_PUBLISHED = 'published'
  STATE_IN_REVIEW = 'in_review'

  WEBSITE_CHANNEL = 'website'
  EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL = 'external_real_estate_portal'
  PRINT_CHANNEL = 'print'
  MICROSITE_CHANNEL = 'microsite'
  CHANNELS = %W(#{WEBSITE_CHANNEL} #{EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL} #{PRINT_CHANNEL} #{MICROSITE_CHANNEL})

  belongs_to :category
  belongs_to :office
  belongs_to :contact, :class_name => 'Employee'
  belongs_to :editor, :class_name => 'Cms::User'
  belongs_to :creator, :class_name => 'Cms::User'

  has_many :appointments
  has_many :reference_projects, :dependent => :nullify

  embeds_one :reference, :as => :referencable
  #deprecate :reference # disable for now, because it will always log as long as we have defined embeds_one

  embeds_one :address, :cascade_callbacks => true, :validate => false # cascade callbacks to guarantee execution of geocoding
  embeds_one :pricing, :validate => false
  embeds_one :figure, :validate => false
  embeds_one :information, :validate => false
  embeds_one :infrastructure, :validate => false
  embeds_one :additional_description

  embeds_many :images, :class_name => 'MediaAssets::Image', :cascade_callbacks => true
  embeds_many :floor_plans, :class_name => 'MediaAssets::FloorPlan', :cascade_callbacks => true
  embeds_many :videos, :class_name => 'MediaAssets::Video', :cascade_callbacks => true
  embeds_many :documents, :class_name => 'MediaAssets::Document', :cascade_callbacks => true

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :floor_plans
  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :documents

  field :state, :type => String, :default => RealEstate::STATE_EDITING
  field :utilization, :type => String, :default => Utilization::LIVING
  field :offer, :type => String, :default => Offer::RENT
  field :channels, :type => Array
  field :title, :type => String
  field :description, :type => String
  field :building_type, :type => String
  field :utilization_description, :type => String
  field :category_label, :type => String, :localize => true # used for sorting, normalized by category.label
  field :microsite_building_project, :type => String # Defines the building project e.g. 'Gartenstadt' or 'Feldpark'

  validates :category_id, :presence => true
  validates :utilization, :presence => true
  validates :offer, :presence => true
  validates :title, :presence => true, :unless => :parking?
  validates :description, :presence => true, :unless => :parking?
  validates :office_id, :presence => true

  after_initialize :init_channels
  after_validation :set_category_label

  delegate :apartment?, :house?, :property?, :to => :top_level_category, :allow_nil => true
  delegate :row_house?, :to => :category, :allow_nil => true
  delegate :coordinates, :to => :address, :allow_nil => true

  scope :published, :where => { :state => STATE_PUBLISHED }
  scope :in_review, :where => { :state => STATE_IN_REVIEW }
  scope :editing, :where => { :state => STATE_EDITING }
  scope :recently_updated, lambda { where( :updated_at.gte => 12.hours.ago ) }
  scope :web_channel, :where => {:channels => WEBSITE_CHANNEL}
  scope :print_channel, :where => { :channels => PRINT_CHANNEL }
  scope :microsite, :where => { :channels => MICROSITE_CHANNEL }

  # Utilization scopes
  scope :living,  :where => { :utilization => Utilization::LIVING }
  scope :working, :where => { :utilization => Utilization::WORKING }
  scope :storing, :where => { :utilization => Utilization::STORING }
  scope :parking, :where => { :utilization => Utilization::PARKING }

  # Offer scopes
  scope :for_rent, :where => { :offer => Offer::RENT }
  scope :for_sale, :where => { :offer => Offer::SALE }

  # Microsite Building Project scopes
  scope :gartenstadt, :where => { :microsite_building_project => Microsite::GARTENSTADT }
  scope :feldpark,    :where => { :microsite_building_project => Microsite::FELDPARK }
  scope :buenzpark,   :where => { :microsite_building_project => Microsite::BUENZPARK }

  def self.mandatory_for_publishing
    %w(address pricing figure information)
  end

  def validate_figure_in_editing_state?
    state_changed? && !parking?
  end

  def validate_figure_in_published_state?
    !parking?
  end

  state_machine :state, :initial => :editing do

    state :editing

    state :in_review do
      # editor needed for review notification
      validates :creator, :presence => true
      validates :editor, :presence => true

      # :if => :state_changed?, # Allows admin to save real estate in_review state
      # :unless => :new_record? # ...otherwise the fabricator can't create real estates 'in_review', any idea?
      validates :address, :presence => true, :if => :state_changed?, :unless => :new_record?
      validates :pricing, :presence => true, :if => :state_changed?, :unless => :new_record?
      validates :figure, :presence => true, :if => :validate_figure_in_editing_state?, :unless => :new_record?
      validates :information, :presence => true, :if => :state_changed?, :unless => :new_record?

      # :if => :state_changed? # Allows admin to save real estate in_review state
      validates_associated :address, :if => :state_changed?
      validates_associated :pricing, :if => :state_changed?
      validates_associated :figure, :if => :validate_figure_in_editing_state?
      validates_associated :information, :if => :state_changed?
    end

    state :published do
      # :unless=>:new_record? # ...otherwise the fabricator can't create real estates in 'published' state, any idea?
      validates :address, :presence => true, :unless => :new_record?
      validates :pricing, :presence => true, :unless => :new_record?
      validates :figure, :presence => true, :if => :validate_figure_in_published_state?, :unless => :new_record?
      validates :information, :presence => true, :unless => :new_record?

      validates_associated :address
      validates_associated :pricing
      validates_associated :figure, :if => :validate_figure_in_published_state?
      validates_associated :information
    end

    event :review_it do
      transition :editing => :in_review
    end

    event :reject_it do
      transition :in_review => :editing
    end

    event :publish_it do
      transition [:editing, :in_review] => :published
    end

    event :unpublish_it do
      transition :published => :editing
    end
  end

  def working_or_storing?
    unless Utilization.all.include? self.utilization
      raise "Unknown utilization '#{self.utilization}'"
    end

    if self.utilization == Utilization::WORKING
      true
    else
      false
    end
  end

  alias_method :commercial_utilization?, :working?
  alias_method :private_utilization?, :living?
  alias_method :storage_utilization?, :storing?
  alias_method :parking_utilization?, :parking?
  alias_method :for_work_or_storage?, :working_or_storing?

  def has_handout?
    for_rent? && channels.include?(RealEstate::PRINT_CHANNEL) && !parking?
  end

  def top_level_category
    category.parent
  end

  def export_to_real_estate_portal?
    channels.include? EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL
  end

  def is_website?
    channels.include? WEBSITE_CHANNEL
  end

  def handout
    @handout ||= Handout.new(self)
  end

  def to_model_access
    ModelAccess.new(offer, utilization, ModelAccess.cms_blacklist)
  end

  def any_descriptions?
    if parking?
      description.present?
    else
      description.present? ||
      additional_description.location.present? ||
      additional_description.interior.present? ||
      additional_description.offer.present? ||
      additional_description.infrastructure.present?
    end
  end

  private
  def init_channels
    self.channels ||= []
  end

  def set_category_label
    self.category_label_translations = self.category.label_translations if category.present?
  end
end
