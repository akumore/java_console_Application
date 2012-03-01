class AppointmentsController < ApplicationController

  def new
    @real_estate = RealEstate.find(params[:real_estate_id])
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.new(params[:appointment])
    if @appointment.save
      render 'confirmation'
    else
      @real_estate = RealEstate.find(params[:real_estate_id])
      @contact = @real_estate.contact
      render 'new'
    end
  end

end