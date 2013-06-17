# encoding: utf-8
class HandoutOrderMailer < ActionMailer::Base
  default :from => "info@screenconcept.ch", :reply_to => 'no-reply@alfred-mueller.ch'

  def handout_order_notification(handout_order, real_estate)
    @handout_order = handout_order
    @real_estate = real_estate
    @contact = @real_estate.contact
    mail  :subject => "Bestellung Objektdokumentation für '#{@real_estate.title}'",
          :reply_to => @handout_order.email.presence,
          :to => @real_estate.contact.email
  end
end
