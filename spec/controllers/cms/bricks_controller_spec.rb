# encoding: utf-8
require 'spec_helper'

describe Cms::BricksController do

  pending "TODO: Spec access control to nested bricks controller. The routing prevents me from doing this right now :("

  #before do
  #  @request.env["devise.mapping"] = Devise.mappings[:users]
  #  sign_in Fabricate(:cms_editor)
  #
  #  @prohibited = 'Sie haben keine Berechtigungen für diese Aktion'
  #
  #  @brick = Fabricate.build :text_brick
  #  @page = Fabricate :page, :bricks => [@brick]
  #end
  #
  #
  #it "can not be accessed on #new" do
  #  get :new, :page_id=>@page.id
  #  response.should redirect_to cms_dashboards_path
  #  flash[:warn].should == @prohibited
  #end
  #
  #it 'can not be accessed on #edit' do
  #  get :edit, :page_id => @page.id, :id => @brick.id
  #  response.should redirect_to cms_dashboards_path
  #  flash[:warn].should == @prohibited
  #end
  #
  #it 'can not be accessed for creating new objects' do
  #  post :create
  #  response.should redirect_to cms_dashboards_path
  #  flash[:warn].should == @prohibited
  #end
  #
  #it 'can not be accessed for updating existing objects' do
  #  put :update, :id => resource.id
  #  response.should redirect_to cms_dashboards_path
  #  flash[:warn].should == @prohibited
  #end
  #
  #it 'can not be accessed for deleting objects' do
  #  delete :destroy, :id => resource.id
  #  response.should redirect_to cms_dashboards_path
  #  flash[:warn].should == @prohibited
  #end
end

