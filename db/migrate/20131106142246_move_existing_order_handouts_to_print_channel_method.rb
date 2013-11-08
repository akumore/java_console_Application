class MoveExistingOrderHandoutsToPrintChannelMethod < Mongoid::Migration

  RealEstate.class_eval do
    field :order_handout, :type => Boolean
  end

  def self.up
    RealEstate.all.each do |real_estate|
      if real_estate.order_handout
        real_estate.channels << RealEstate::PRINT_CHANNEL
        real_estate.print_channel_method = RealEstate::PRINT_CHANNEL_METHOD_ORDER
      else
        if real_estate.channels.include? RealEstate::PRINT_CHANNEL
          real_estate.print_channel_method = RealEstate::PRINT_CHANNEL_METHOD_PDF_DOWNLOAD
        end
      end
      real_estate.save(:validate => false)
    end
  end

  def self.down
    RealEstate.all.each do |real_estate|
      if RealEstate::PRINT_CHANNEL_METHOD_ORDER == real_estate.print_channel_method
        real_estate.channels.delete(RealEstate::PRINT_CHANNEL)
        real_estate.order_handout = true
      end
      real_estate.print_channel_method = ''
      real_estate.save(:validate => false)
    end
  end
end
