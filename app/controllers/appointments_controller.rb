require 'google_analytics_category_translator'

class AppointmentsController < ApplicationController
  include GoogleAnalyticsCategoryTranslator

  def new
    @real_estate = RealEstateDecorator.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build
  end

  def create
    @real_estate = RealEstateDecorator.find params[:real_estate_id]
    @appointment = @real_estate.appointments.build params[:appointment]
    if @appointment.save
      AppointmentMailer.appointment_notification(@appointment).deliver
      log_event(translate_category(@real_estate), 'Kontakt Formular', @real_estate.address.simple)
      render 'show'
    else
      render 'new'
    end
  end

end
