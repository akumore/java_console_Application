class AppointmentsController < ApplicationController

  def new
    @real_estate = RealEstateDecorator.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build
  end

  def create
    @real_estate = RealEstateDecorator.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build params[:appointment]
    if @appointment.save
      AppointmentMailer.appointment_notification(@appointment).deliver
      log_event("#{t("real_estates.search_filter.#{@real_estate.offer}")} #{t("real_estates.search_filter.#{@real_estate.utilization}")}", 'Kontakt Formular', @real_estate.address.simple)
      render 'show'
    else
      render 'new'
    end
  end

end
