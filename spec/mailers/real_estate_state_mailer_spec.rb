# encoding: utf-8
require "spec_helper"

describe RealEstateStateMailer do
  let :creator do
    Fabricate(:cms_editor)
  end

  let :editor do
    Fabricate(:cms_editor, :email => 'editor@mailerspec.local')
  end

  let :admin do
    Fabricate(:cms_admin, :admin => 'admin@mailerspec.local')
  end

  let :real_estate do
    Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :reference => Fabricate.build(:reference),
      :contact => Fabricate(:employee),
      :state => RealEstate::STATE_IN_REVIEW,
      :creator => creator,
      :editor => editor
    )
  end

  describe '#review_notification' do

    before do
      Fabricate(:cms_admin, :email => 'admin1@screenconcept.ch')
      Fabricate(:cms_admin, :email => 'admin2@screenconcept.ch')
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
      review_mail.to.should == Cms::User.receiving_review_emails.map(&:email)
    end

    it 'includes the title in the subject' do
      review_mail.subject.should == "Bitte publizieren: #{real_estate.title}"
    end

    it "includes the review message in the body" do
      review_mail.body.should match /Das Objekt.*wurde von.*erfasst und kann publiziert werden\./
    end

    it "includes all channels in the channel list" do
      real_estate.channels.each do |channel|
        review_mail.body.should match /^\* #{I18n.t("cms.real_estates.form_channels.channels.#{channel}", :locale=>:de)}$/
      end
    end
  end

  describe '#reject_notification' do

    let :reject_mail do
      RealEstateStateMailer.reject_notification(real_estate, admin).deliver
    end

    it "sends the reject mail notification" do
      lambda {
        RealEstateStateMailer.reject_notification(real_estate, admin).deliver
      }.should change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'sends the reject mail to the editor' do
      reject_mail.to.should == [editor.email]
    end

    it 'includes the title in the subject' do
      reject_mail.subject.should == "Freigabe zurückgewiesen: #{real_estate.title}"
    end

    it "includes the rejecting admin in the body" do
      reject_mail.body.should match /#{admin.email}/
    end

    it "includes the title in the body" do
      reject_mail.body.should match /#{real_estate.title}/
    end

    it "includes the reject message in the body" do
      reject_mail.body.should match /Die Freigabe des Objektes.*wurde von.*zurückgewiesen\./
    end

  end
end
