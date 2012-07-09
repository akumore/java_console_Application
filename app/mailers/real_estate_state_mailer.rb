# encoding: utf-8

class RealEstateStateMailer < ActionMailer::Base
  default from: "info@screenconcept.ch"

  def review_notification(real_estate)
    @real_estate = real_estate

    mail :subject => "Bitte publizieren: #{real_estate.title}",
      :to => Cms::User.receiving_review_emails.map(&:email), reply_to: real_estate.editor.email
  end

  def reject_notification(real_estate, admin)
    @real_estate = real_estate
    @admin = admin

    mail :subject => "Freigabe zurückgewiesen: #{real_estate.title}",
      :to => real_estate.editor.email, reply_to: admin.email
  end
end
