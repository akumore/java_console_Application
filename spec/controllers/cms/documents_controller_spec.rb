# encoding: utf-8
require 'spec_helper'

describe 'Real Estate Wizard' do
  before do
    sign_in(Fabricate(:cms_admin))
  end

  describe Cms::DocumentsController do

    context "On a published real estate" do
      before do
        @document = Fabricate.build(:media_assets_document)
        @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :documents => [@document]
      end

      it "can't create a new document" do
        expect {
          post 'create', :real_estate_id => @real_estate.id, :document => Fabricate.attributes_for(:media_assets_document)
        }.should_not change { @real_estate.reload.documents.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't edit the document" do
        get 'edit', :real_estate_id => @real_estate.id, :id => @document.id
        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't update the document" do
        expect {
          put 'update', :real_estate_id => @real_estate, :id => @document.id, :document => Fabricate.attributes_for(:media_assets_document, :title => 'Updated Document Title')
        }.should_not change { @document.reload.title }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end

      it "can't destroy the document" do
        expect {
          delete 'destroy', :real_estate_id => @real_estate.id, :id => @document.id
        }.should_not change { @real_estate.reload.documents.count }

        response.should redirect_to [:cms, @real_estate, :media_assets]
      end
    end

  end
end
