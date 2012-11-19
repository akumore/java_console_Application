require 'copy_real_estate'

class RealEstate
  include Offer::Accessors
  include Utilization::Accessors

  include Mongoid::Document
  include Mongoid::Timestamps
  extend CopyRealEstate

  UTILIZATION_PRIVATE = Utilization::LIVING
  UTILIZATION_COMMERICAL = Utilization::WORKING
  UTILIZATION_STORAGE = Utilization::STORAGE
  UTILIZATION_PARKING = Utilization::PARKING

  UTILIZATIONS = Utilization.all

  BUILDING_CORNER_HOUSE = 'corner_house'
  BUILDING_MIDDLE_HOUSE = 'middle_house'

  OFFER_FOR_RENT = Offer::RENT
  OFFER_FOR_SALE = Offer::SALE

  STATE_EDITING = 'editing'
  STATE_PUBLISHED = 'published'
  STATE_IN_REVIEW = 'in_review'

  WEBSITE_CHANNEL = 'website'
  EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL = 'external_real_estate_portal'
  PRINT_CHANNEL = 'print'
  MICROSITE_CHANNEL = 'microsite'
  CHANNELS = %W(#{WEBSITE_CHANNEL} #{EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL} #{PRINT_CHANNEL} #{MICROSITE_CHANNEL})

  belongs_to :category
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
  field :utilization, :type => String, :default => RealEstate::UTILIZATION_PRIVATE
  field :offer, :type => String, :default => RealEstate::OFFER_FOR_RENT
  field :channels, :type => Array, :default => [RealEstate::WEBSITE_CHANNEL]
  field :title, :type => String
  field :description, :type => String
  field :building_type, :type => String
  field :utilization_description, :type => String
  field :category_label, :type => String, :localize => true # used for sorting, normalized by category.label

  validates :category_id, :presence => true
  validates :utilization, :presence => true
  validates :offer, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

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
  scope :living, :where => { :channels => UTILIZATION_PRIVATE }
  scope :working, :where => { :channels => UTILIZATION_COMMERICAL }
  scope :storage, :where => { :channels => UTILIZATION_STORAGE }
  scope :parking, :where => { :channels => UTILIZATION_PARKING }

  class << self
    extend ActiveSupport::Memoizable

    def mandatory_for_publishing
      metadata = RealEstate.relations.values.select { |r| r.relation == Mongoid::Relations::Embedded::One }
      mandatory_relations = metadata.select { |relation| relation.class_name.constantize.validators.map(&:class).include?(Mongoid::Validations::PresenceValidator) }
      mandatory_relations.map(&:key)
    end

    memoize :mandatory_for_publishing
  end

  state_machine :state, :initial => :editing do

    state :editing

    state :in_review do

      # editor needed for review notification
      validates :creator, :presence => true
      validates :editor, :presence => true
      validates *RealEstate.mandatory_for_publishing, :presence=>true,
                :if=>:state_changed?, # Allows admin to save real estate in_review state
                :unless=>:new_record? # ...otherwise the fabricator can't create real estates 'in_review', any idea?

      validates_associated *RealEstate.mandatory_for_publishing,
                           :if=>:state_changed? # Allows admin to save real estate in_review state
    end

    state :published do
      validates *RealEstate.mandatory_for_publishing, :presence=>true,
                :unless=>:new_record? # ...otherwise the fabricator can't create real estates in 'published' state, any idea?

      validates_associated *RealEstate.mandatory_for_publishing
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

  def commercial_utilization?
    self.utilization == RealEstate::UTILIZATION_COMMERICAL
  end

  def private_utilization?
    self.utilization == RealEstate::UTILIZATION_PRIVATE
  end

  def storage_utilization?
    self.utilization == Utilization::STORAGE
  end

  def parking_utilization?
    self.utilization == Utilization::PARKING
  end

  def for_work_or_storage?
    unless RealEstate::UTILIZATIONS.include? self.utilization
      raise "Unknown utilization '#{self.utilization}'"
    end

    if self.utilization == RealEstate::UTILIZATION_COMMERICAL
      true
    else
      false
    end
  end

  def has_handout?
    for_rent? && channels.include?(RealEstate::PRINT_CHANNEL)
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

  private
  def init_channels
    self.channels ||= []
  end

  def set_category_label
    self.category_label_translations = self.category.label_translations if category.present?
  end

end
