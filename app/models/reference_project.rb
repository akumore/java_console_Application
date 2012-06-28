class ReferenceProject
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope asc(:position)

  field :title,       :type => String
  field :description, :type => String
  field :offer,       :type => String, :default => RealEstate::OFFER_FOR_RENT
  field :url,         :type => String
  field :locale,      :type => String, :default => 'de'
  field :image,       :type => String
  field :position,    :type => Integer

  validates :title, :description, :locale, :offer, :image, :presence => true

  #mount_uploader :image, ReferenceProjectImageUploader

  #before_create :setup_position

  #private
  #def setup_position
    #self.position = news_item.images.max(:position) + 1
  #end

end
