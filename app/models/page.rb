class Page

  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :bricks, :class_name => 'Brick::Base'
  accepts_nested_attributes_for :bricks

  field :title, :type => String
  field :name, :type => String
  field :locale, :type => String

  before_validation :create_name, :on => :save

  validates :title, :presence => true
  validates :name, :uniqueness => true, :presence => true
  validates :locale, :presence => true, :inclusion => I18n.available_locales.map(&:to_s)

  private

  def create_name
    self.name = [locale, name].join '/'
  end
end
