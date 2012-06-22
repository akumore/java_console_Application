# encoding: utf-8

class ContactMailer < ActionMailer::Base
  default :from => "info@screenconcept.ch", :reply_to => 'no-reply@alfred-mueller.ch'

  def contact_notification(contact)
    @contact = contact
    mail  :subject => "Kontaktanfrage von '#{contact.firstname} #{contact.lastname}'",
          :reply_to => contact.email.presence,
          :to => 'mail@alfred-mueller.ch'
  end
end
