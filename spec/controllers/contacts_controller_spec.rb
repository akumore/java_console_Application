require 'spec_helper'

describe ContactsController, fp: true do

  let(:mailer_stub) { @mailer_stub = stub(:deliver => true) }
  before do
    ContactMailer.stub!(:contact_notification).and_return(mailer_stub)
  end

  describe "GET new" do

    it "prepares new contact" do
      mailer_stub.should_not_receive(:deliver)
      get :new, locale: 'de'
      expect(assigns(:contact).new_record?).to be_true
    end

  end

  describe "POST create" do

    it "does not deliver email if form not filled properly" do
      mailer_stub.should_not_receive(:deliver)
      post :create, locale: 'de', contact: {}
    end

    it "does deliver email if form filled properly" do
      mailer_stub.should_receive(:deliver)
      post :create, locale: 'de', contact: Fabricate.attributes_for(:contact).merge(unnecessary_field: '')
    end

    it "does not deliver email if spam protect field is fillde" do
      mailer_stub.should_not_receive(:deliver)
      post :create, locale: 'de', contact: Fabricate.attributes_for(:contact).merge(unnecessary_field: 'dsfkdsf')
    end

  end

end
