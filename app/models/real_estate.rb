require 'copy_real_estate'
require 'field_access'

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
  STATE_ARCHIVED = 'archived'

  WEBSITE_CHANNEL = 'website'
  EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL = 'external_real_estate_portal'
  MICROSITE_CHANNEL = 'microsite'
  PRINT_CHANNEL = 'print'
  PRINT_CHANNEL_METHOD_PDF_DOWNLOAD = 'print_method_pdf_download'
  PRINT_CHANNEL_METHOD_ORDER = 'print_method_order'
  CHANNELS = %W(#{WEBSITE_CHANNEL} #{EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL} #{PRINT_CHANNEL} #{MICROSITE_CHANNEL})

  belongs_to :category
  belongs_to :office
  belongs_to :contact, :class_name => 'Employee'
  belongs_to :editor, :class_name => 'Cms::User'
  belongs_to :creator, :class_name => 'Cms::User'

  has_many :appointments
  has_many :reference_projects, :dependent => :nullify

  embeds_one :reference
  embeds_one :microsite_reference
  embeds_one :address, :cascade_callbacks => true, :validate => false # cascade callbacks to guarantee execution of geocoding
  embeds_one :pricing, :validate => false
  embeds_one :figure, :validate => false
  embeds_one :information, :validate => false

  embeds_many :images, :class_name => 'MediaAssets::Image', :cascade_callbacks => true
  embeds_many :floor_plans, :class_name => 'MediaAssets::FloorPlan', :cascade_callbacks => true
  embeds_many :videos, :class_name => 'MediaAssets::Video', :cascade_callbacks => true
  embeds_many :documents, :class_name => 'MediaAssets::Document', :cascade_callbacks => true

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :floor_plans
  accepts_nested_attributes_for :videos
  accepts_nested_attributes_for :documents

  field :language, :type => String, :default => I18n.locale
  field :state, :type => String, :default => RealEstate::STATE_EDITING
  field :utilization, :type => String, :default => Utilization::LIVING
  field :offer, :type => String, :default => Offer::RENT
  field :channels, :type => Array
  field :print_channel_method, :type => String # defines if handout is published on website or customer has to order it
  field :title, :type => String
  field :description, :type => String
  field :building_type, :type => String
  field :utilization_description, :type => String
  field :category_label, :type => String, :localize => true # used for sorting, normalized by category.label
  field :microsite_building_project, :type => String # Defines the building project e.g. 'Gartenstadt' or 'Feldpark'
  field :link_url, :type => String # Link to project website e.g. www.feldpark-zug.ch
  field :show_application_form, :type => Boolean, :default => true # Used to show application form in frontend or nah

  validates :category_id, :presence => true
  validates :utilization, :presence => true
  validates :utilization_description, :length => { :maximum => 25 }
  validates :offer, :presence => true
  validates :title, :presence => true, :unless => :parking?
  validates :description, :presence => true, :unless => :parking?
  validates :office_id, :presence => true
  validates :microsite_building_project,
    :presence => true,
    :inclusion => { :in => MicrositeBuildingProject.all },
    :if => :is_microsite?
  validates :any_reference_key, :presence => true, :if => :export_to_real_estate_portal?
  validate :validates_uniqueness_of_key_composition, :if => :export_to_real_estate_portal?

  after_validation :set_category_label
  after_validation :refresh_reference
  after_initialize :init_channels
  after_initialize :init_microsite_reference

  delegate :apartment?, :house?, :property?, :to => :top_level_category, :allow_nil => true
  delegate :row_house?, :to => :category, :allow_nil => true
  delegate :coordinates, :to => :address, :allow_nil => true

  scope :published, :where => { :state => STATE_PUBLISHED }
  scope :in_review, :where => { :state => STATE_IN_REVIEW }
  scope :editing, :where => { :state => STATE_EDITING }
  scope :archived, -> { where(:state => STATE_ARCHIVED) }
  scope :without_archived, -> { where(:state.ne => STATE_ARCHIVED) }
  scope :recently_updated, -> { where( :updated_at.gte => 12.hours.ago ) }
  scope :web_channel, :where => {:channels => WEBSITE_CHANNEL}
  scope :print_channel, :where => { :channels => PRINT_CHANNEL, :print_channel_method.ne => PRINT_CHANNEL_METHOD_ORDER }
  scope :microsite, :where => { :channels => MICROSITE_CHANNEL }
  scope :named_microsite, ->(name) { microsite.where(:microsite_building_project => name) }
  scope :default_order, -> { order_by(['address.city', 'asc'], ['address .street', 'asc'], ['address.street_number', 'asc']) }

  # Utilization scopes
  scope :living,  :where => { :utilization => Utilization::LIVING }
  scope :working, :where => { :utilization => Utilization::WORKING }
  scope :storing, :where => { :utilization => Utilization::STORING }
  scope :parking, :where => { :utilization => Utilization::PARKING }

  # Offer scopes
  scope :for_rent, :where => { :offer => Offer::RENT }
  scope :for_sale, :where => { :offer => Offer::SALE }

  def self.mandatory_for_publishing
    %w(address pricing figure)
  end

  def validate_figure_in_editing_state?
    state_changed? && !parking?
  end

  def validate_figure_in_published_state?
    !parking?
  end

  def within_language
    old_locale = I18n.locale
    begin
      I18n.locale = self.language.to_sym
      yield
    ensure
      I18n.locale = old_locale
    end
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

      # :if => :state_changed? # Allows admin to save real estate in_review state
      validates_associated :address, :if => :state_changed?
      validates_associated :pricing, :if => :state_changed?
      validates_associated :figure, :if => :validate_figure_in_editing_state?
    end

    state :published do
      # :unless=>:new_record? # ...otherwise the fabricator can't create real estates in 'published' state, any idea?
      validates :address, :presence => true, :unless => :new_record?
      validates :pricing, :presence => true, :unless => :new_record?
      validates :figure, :presence => true, :if => :validate_figure_in_published_state?, :unless => :new_record?

      validates_associated :address
      validates_associated :pricing
      validates_associated :figure, :if => :validate_figure_in_published_state?
    end

    state :archived

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

    event :archive_it do
      transition [:editing, :published] => :archived
    end

    event :reactivate_it do
      transition :archived => :editing
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
     (channels.include?(PRINT_CHANNEL) && print_channel_method != PRINT_CHANNEL_METHOD_ORDER) && !parking?
  end

  def order_handout?
    channels.include?(PRINT_CHANNEL) && print_channel_method == PRINT_CHANNEL_METHOD_ORDER
  end

  def top_level_category
    category.parent
  end

  def export_to_real_estate_portal?
    channels.include? EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL
  end

  def is_microsite?
    channels.include? MICROSITE_CHANNEL
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

  def field_access
    FieldAccess.new(offer, utilization, FieldAccess.cms_blacklist)
  end

  private
  def init_channels
    self.channels ||= []
  end

  def init_microsite_reference
    self.microsite_reference ||= MicrositeReference.new
  end

  def refresh_reference
    if self.export_to_real_estate_portal?
      self.reference ||= Reference.new
    else
      self.reference = Reference.new
    end
  end

  def set_category_label
    self.category_label_translations = self.category.label_translations if category.present?
  end

  def any_reference_key
    (reference.property_key.presence || reference.building_key.presence || reference.unit_key.presence) if reference.present?
  end

  def validates_uniqueness_of_key_composition
    allowed_keys = [:property_key, :building_key, :unit_key]
    attr_hash = {}
    allowed_keys.each { |a| attr_hash[a] = self.reference.send(a) }

    matching_real_estates = RealEstate.matching_real_estates(attr_hash)
    matching_real_estates.delete(self)

    if matching_real_estates.count > 0
      errors.add(:reference_key_combination, I18n.t('cms.real_estates.form.errors.reference_key_combination.constraint'))
    end
  end

  def self.matching_real_estates(attributes)
    attribs = {}
    attributes.each_pair{ |k,v| attribs["reference.#{k}"] = v }
    RealEstate.where(attribs).to_a
  end
end
