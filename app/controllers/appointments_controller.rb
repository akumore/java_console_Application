class AppointmentsController < ApplicationController

  def new
    @real_estate = RealEstate.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build
  end

  def create
    @real_estate = RealEstate.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build params[:appointment]
    if @appointment.save
      #TODO Send email or do what ever you want with this!
      render 'show'
    else
      render 'new'
    end
  end

end