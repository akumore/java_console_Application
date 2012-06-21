# encoding: utf-8
require "spec_helper"

describe RealEstateStateMailer do
  describe '#review_notification' do

    before do
      Fabricate(:cms_admin, :email => 'admin1@screenconcept.ch')
      Fabricate(:cms_admin, :email => 'admin2@screenconcept.ch')
    end

    let :editor do
      Fabricate(:cms_editor)
    end

    let :admin do
    end

    let :real_estate do
      Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :reference => Fabricate.build(:reference),
        :contact => Fabricate(:employee),
        :state => RealEstate::STATE_IN_REVIEW,
        :editor => editor
      )
    end

    let :review_mail do
      RealEstateStateMailer.review_notification(real_estate).deliver
    end

    it "sends the review mail notification" do
      lambda {
        RealEstateStateMailer.review_notification(real_estate).deliver
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'sends the review mail to all admins' do
      review_mail.to.should == Cms::User.admins.map(&:email)
    end

    it 'includes the title in the subject' do
      review_mail.subject.should == "Zur Verifizierung freigegeben: #{real_estate.title}"
    end

    it "includes all channels in the channel list" do
      real_estate.channels.each do |channel|
        review_mail.body.should match /^\* #{I18n.t("cms.real_estates.form.channels.#{channel}", :locale=>:de)}$/
      end
    end

    it "prints" do
      puts review_mail
    end
  end

  describe '#reject_notification' do

  end
end
