class HandoutOrdersController < ApplicationController

  def new
    @real_estate = RealEstateDecorator.find(params[:real_estate_id])
    @handout_order = HandoutOrder.new
  end

  def create
    @handout_order = HandoutOrder.new(params[:handout_order])
    @real_estate = RealEstateDecorator.find(params[:real_estate_id])
    if @handout_order.save
      HandoutOrderMailer.handout_order_notification(@handout_order, @real_estate).deliver
      render 'show'
    else
      render 'new'
    end
  end
end
