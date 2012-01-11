class RealEstate
  include Mongoid::Document
  include Mongoid::Timestamps

  UTILIZATION_PRIVATE = :private
  UTILIZATION_COMMERICAL = :commercial

  OFFER_FOR_RENT = :for_rent
  OFFER_FOR_SALE = :for_sale

  CHANNELS = [:website, :homegate, :print]

  belongs_to :category
  belongs_to :contact
  embeds_one :reference

  field :utilization, :type => String
  field :offer, :type => String
  field :channels, :type => Array
  field :title, :type => String
  field :property_name, :type => String
  field :description, :type => String
  field :short_description, :type => String
  field :keywords, :type => String
  field :is_first_marketing, :type => Boolean
end
