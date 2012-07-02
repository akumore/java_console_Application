# encoding: utf-8
require 'spec_helper'


describe Cms::ReferenceProjectsController do
  login_cms_user

  let :first do
    Fabricate :reference_project, :position => 1
  end

  let :second do
    Fabricate :reference_project, :position => 2
  end

  let :third do
    Fabricate :reference_project, :position => 3
  end

  describe '#edit' do
    it 'assigns the needed variables' do
      get :edit, :id => first.id
      assigns(:real_estates).should eq(RealEstate.all)
      assigns(:reference_project).should eq(first)
    end
  end

  describe '#sort' do
    it 'should update the position attribute' do
      post :sort, :reference_projects => [
        first.id.to_s => {:position => 3},
        second.id.to_s => {:position => 2},
        third.id.to_s => {:position => 1},
      ]
      third.reload.position.should == 1
      second.reload.position.should == 2
      first.reload.position.should == 3
    end
  end

  describe '#update' do
    let :reference_project do
      Fabricate :reference_project
    end

    describe 'on success' do
      it 'should redirect to index' do
        put :update, :id  => reference_project.id
        response.should redirect_to cms_reference_projects_path(:content_locale => I18n.locale)
      end
    end

    describe 'on failure' do
      it "assigns the real_estate list on save errors" do
        ReferenceProject.stub(:find => reference_project)
        reference_project.stub(:update_attributes => false)
        put :update, :id => reference_project.id
        assigns(:real_estates).should eq(RealEstate.all)
      end
    end

  end
end

