# encoding: utf-8

class RealEstateStateMailer < ActionMailer::Base
  default from: "info@screenconcept.ch"

  def review_notification(real_estate)
    @real_estate = real_estate

    mail :subject => "Zur Verifizierung freigegeben: #{real_estate.title}",
      :to => Cms::User.admins.map(&:email), reply_to: real_estate.editor.email
  end

  def reject_notification(real_estate)
    #@real_estate = real_estate

    #mail :subject => "Zur Verifizierung freigegeben: #{real_estate.title}",
      #:to => Cms::User.admins.map(&:email)
  end
end
