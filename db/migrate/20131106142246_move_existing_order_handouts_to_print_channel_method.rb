class MoveExistingOrderHandoutsToPrintChannelMethod < Mongoid::Migration

  RealEstate.class_eval do
    field :order_handout, :type => Boolean
  end

  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.order_handout
        real_estate.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_ORDER)
      else
        real_estate.update_attribute(:print_channel_method, RealEstate::PRINT_CHANNEL_METHOD_PDF_DOWNLOAD)
      end
    end
  end

  def self.down
    RealEstate.all.each do |real_estate|
      real_estate.update_attribute(:print_channel_method, '')
    end
  end
end
