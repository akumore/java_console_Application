# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  login_cms_user

  describe Cms::RealEstatesController do
    let :category do
      Fabricate :category
    end

    let :creator do
      Fabricate :cms_editor
    end

    let :editor do
      Fabricate :cms_editor
    end

    let :admin do
      Fabricate :cms_admin
    end


    describe '#create' do
      it 'redirects to the new address tab' do
        put :create, :real_estate => Fabricate.attributes_for(:real_estate, :category_id => category.id)
        response.should redirect_to new_cms_real_estate_address_path(RealEstate.first)
      end

      it 'assigns a creator' do
        put :create, :real_estate => Fabricate.attributes_for(:real_estate, :category_id => category.id)
        controller.instance_variable_get("@real_estate").creator.should == controller.current_user
      end
    end


    describe '#update' do
      before do
        @real_estate = Fabricate :real_estate, :category => category
      end

      it 'redirects to the new address tab without an existing address' do
        put :update, :id => @real_estate.id
        response.should redirect_to new_cms_real_estate_address_path(@real_estate)
      end

      it 'redirects to the edit address tab with an existing address' do
        @real_estate.address = Fabricate.build(:address)

        put :update, :id => @real_estate.id
        response.should redirect_to edit_cms_real_estate_address_path(@real_estate)
      end

      context 'as an admin' do
        before do
          @real_estate.editor = editor
          @real_estate.save
        end

        it 'remains last edited by the editor' do
          current_editor = @real_estate.editor
          put :update, :id => @real_estate.id
          @real_estate.reload.editor.editor?.should be_true
        end
      end

      context 'as an editor' do
        before do
          controller.stub!(:current_user).and_return editor
          @real_estate.editor = editor
          @real_estate.save
        end

        it 'is last edited by the editor' do
          current_editor = @real_estate.reload.editor
          put :update, :id => @real_estate.id
          @real_estate.reload.editor.editor?.should be_true
        end
      end

      describe "notifications" do
        describe '#review_it' do
          before do
            @real_estate = Fabricate :real_estate, :category => category
            RealEstate.stub!(:find).and_return(@real_estate)
            @real_estate.stub!(:update_attributes).and_return(true)
            @mailer_stub = stub(:deliver => true)
            RealEstateStateMailer.stub!(:review_notification).and_return(@mailer_stub)
            controller.stub!(:current_user).and_return(editor)
          end

          it 'sends a notification if state_event is review_it' do
            RealEstateStateMailer.should_receive(:review_notification).with(@real_estate)
            @mailer_stub.should_receive(:deliver)
            put :update, :id => @real_estate.id, :real_estate => { :state_event => 'review_it' }
          end

          it 'does not send a notification if state_event is not review_it' do
            RealEstateStateMailer.should_not_receive(:review_notification)
            put :update, :id => @real_estate.id, :real_estate => { :state_event => 'publish_it' }
          end

          it 'does not send a notification if state_event not available' do
            RealEstateStateMailer.should_not_receive(:review_notification)
            put :update, :id => @real_estate.id
          end

        end

        describe '#reject_it' do
          before do
            @real_estate = Fabricate :real_estate, :category => category
            RealEstate.stub!(:find).and_return(@real_estate)
            @real_estate.stub!(:update_attributes).and_return(true)
            @mailer_stub = stub(:deliver => true)
            RealEstateStateMailer.stub!(:reject_notification).and_return(@mailer_stub)
            controller.stub!(:current_user).and_return(admin)
          end

          it 'sends a notification if state_event is reject_it' do
            RealEstateStateMailer.should_receive(:reject_notification).with(@real_estate, admin)
            @mailer_stub.should_receive(:deliver)
            put :update, :id => @real_estate.id, :real_estate => { :state_event => 'reject_it' }
          end

          it 'does not send a notification if state_event is not reject_it' do
            RealEstateStateMailer.should_not_receive(:reject_notification)
            put :update, :id => @real_estate.id, :real_estate => { :state_event => 'publish_it' }
          end

          it 'does not send a notification if state_event not available' do
            RealEstateStateMailer.should_not_receive(:reject_notification)
            put :update, :id => @real_estate.id
          end
        end
      end
    end

    describe '#authorization as an admin' do
      before do
        @real_estate = Fabricate :published_real_estate,
          :category => Fabricate(:category),
          :address => Fabricate.build(:address),
          :pricing => Fabricate.build(:pricing),
          :information => Fabricate.build(:information),
          :figure => Fabricate.build(:figure)
        @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
      end

      it 'prevents from accessing #edit' do
        get :edit, :id => @real_estate.id
        response.should redirect_to [:cms, @real_estate]
        flash[:alert].should == @access_denied
      end

      it "doesn't prevents admins from accessing #update because of changing state requests" do
        put :update, :id => @real_estate.id
        response.should redirect_to [:cms, @real_estate]
        flash[:alert].should_not == @access_denied
      end

      it "doesn't allow to destroy real_estate in state 'published'" do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category)

        delete :destroy, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied

      end

      %w(editing in_review).each do |state|
        it "allows to destroy real estate in state '#{state}'" do
          real_estate = Fabricate :real_estate, :state => state, :category => Fabricate(:category), :creator => creator, :editor => editor

          delete :destroy, :id => real_estate.id
          response.should redirect_to cms_real_estates_url
          flash[:notice].should == I18n.t('cms.real_estates.index.destroyed', :title => real_estate.title)
        end
      end
    end


    describe '#authorization as an editor' do
      before do
        controller.current_user.stub!(:role).and_return('editor')
        @access_denied = "Sie haben keine Berechtigungen für diese Aktion"
      end

      it 'prevents from accessing #edit' do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category)

        get :edit, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end

      it "doesn't prevent editors from accessing #update because of changing state requests" do
        real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :address => Fabricate.build(:address),
                                :pricing => Fabricate.build(:pricing), :information => Fabricate.build(:information),
                                :figure => Fabricate.build(:figure)

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should_not == @access_denied
      end

      it "prevents from updating real estate 'in_review'" do
        real_estate = Fabricate :real_estate, :state => 'in_review', :category => Fabricate(:category), :creator => creator, :editor => editor

        put :update, :id => real_estate.id
        response.should redirect_to [:cms, real_estate]
        flash[:alert].should == @access_denied
      end

      it "allows to destroy real_estate in 'editing'" do
        real_estate = Fabricate :real_estate, :state => 'editing', :category => Fabricate(:category)

        delete :destroy, :id=>real_estate.id
        response.should redirect_to cms_real_estates_url
        flash[:notice].should == I18n.t('cms.real_estates.index.destroyed', :title => real_estate.title)
      end

      %w(in_review published).each do |state|
        it "doesn't allow to destroy real estate in state '#{state}'" do
          real_estate = Fabricate :real_estate, :state => state, :category => Fabricate(:category), :creator => Fabricate(:cms_editor), :editor => Fabricate(:cms_editor)

          delete :destroy, :id => real_estate.id
          response.should redirect_to [:cms, real_estate]
          flash[:alert].should == @access_denied
        end
      end

    end

  end
end
