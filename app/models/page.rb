class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Ancestry

  embeds_many :bricks, class_name: 'Brick::Base'
  accepts_nested_attributes_for :bricks
  has_ancestry

  field :title, type: String
  field :name, type: String
  field :locale, type: String
  field :seo_title, type: String
  field :seo_description, type: String

  validates :title, :name, presence: true
  validates :locale, presence: true, inclusion: I18n.available_locales.map(&:to_s)
  validates_uniqueness_of :name,  scope: :locale

  def subnavigation
    bricks.where(_type: 'Brick::Title').skip(1)
  end

  class << self
    def jobs_page
      where(name: 'jobs', locale: I18n.locale).first
    end

    def company_page
      where(name: 'company', locale: I18n.locale).first
    end
  end
end
