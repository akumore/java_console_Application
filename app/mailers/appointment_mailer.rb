# encoding: utf-8

class AppointmentMailer < ActionMailer::Base
  default :from => "info@screenconcept.ch", :reply_to => 'no-reply@alfred-mueller.ch'

  def appointment_notification(appointment)
    @appointment = appointment
    mail  :subject => "Terminanfrage für '#{appointment.real_estate.title}'", 
          :reply_to => appointment.email.presence,
          :to => appointment.real_estate.contact.email
  end
end
