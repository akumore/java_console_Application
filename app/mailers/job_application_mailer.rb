# encoding: utf-8

class JobApplicationMailer < ActionMailer::Base
  default from: "info@screenconcept.ch", reply_to: "no-reply@screenconcept.ch", to: "heidi.rohner@alfred-mueller.ch"

  def application_notification(application)
    @application, @job = application, application.job
    attachments[application.attachment.filename] = File.read(application.attachment.path) if @application.attachment?

    mail :subject => application_notification_subject(@application)
  end

  private
  def application_notification_subject(application)
    if application.unsolicited?
      "Initiativbewerbung über Webseite eingegangen"
    else
      %(Bewerbung für Job "#{application.job.title}" über Webseite eingegangen)
    end
  end
end
