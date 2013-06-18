# encoding: utf-8
require "spec_helper"

describe HandoutOrderMailer do
  monkey_patch_default_url_options

  let :real_estate do
    Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :reference => Fabricate.build(:reference),
      :contact => Fabricate(:employee)
    )
  end

  let :handout_order do
    Fabricate(:handout_order)
  end

  let :handout_order_mail do
    HandoutOrderMailer.handout_order_notification(handout_order, real_estate).deliver
  end

  it "sends the handout order notification" do
    lambda {
      HandoutOrderMailer.handout_order_notification(handout_order, real_estate).deliver
    }.should change(ActionMailer::Base.deliveries, :size).by(1)
  end

  it 'sends the application mail to the real estates assigned contact person' do
    handout_order_mail.to.should == [real_estate.contact.email]
  end

  it 'sets the reply address to the person requesting the handout order' do
    handout_order_mail.reply_to.should == [handout_order.email]
  end

  describe 'Subject of the handout order notification' do
    it 'contains the real estate\'s title' do
      handout_order_mail.subject.should match real_estate.title
    end
  end

  I18n.available_locales.each do |locale|
    describe "Content of application notification for locale '#{locale}'" do
      before do
        I18n.locale = locale
      end

      after do
        I18n.locale = :de
      end

      it 'contains the title of the real estate the handout order is for' do
        handout_order_mail.body.should match real_estate.title
      end

      it 'contains a link to the real estate it is for' do
        handout_order_mail.body.should match(real_estate_url(real_estate))
      end

      it 'contains the date the handout order was entered' do
        handout_order_mail.body.should match I18n.l(handout_order.created_at, :locale => :de)
      end

      [:company, :firstname, :lastname, :email, :phone, :street, :zipcode, :city].each do |name|
        it "contains the #{name} of the applicant" do
          handout_order_mail.body.should match handout_order.send(name)
        end
      end
    end
  end
end
