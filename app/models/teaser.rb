class Teaser
  include Mongoid::Document
  field :title, :type => String
  field :link, :type => String
  field :href, :type => String
end
