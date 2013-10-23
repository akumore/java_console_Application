# encoding: utf-8
require 'spec_helper'

describe "Cms::Documents" do
  login_cms_editor

  describe '#new' do
    before do
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'adds a document' do
      visit new_cms_real_estate_document_path(@real_estate)

      fill_in 'Titel', :with => 'Das neue Dokument'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/document.pdf"

      expect {
        click_on 'Dokument speichern'
      }.to change { @real_estate.reload.documents.count }.by(1)
    end

    it "doesn't add document if upload has the wrong content type" do
      visit new_cms_real_estate_document_path(@real_estate)

      fill_in 'Titel', :with => 'This is no document'
      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/image.jpg"

      expect {
        click_on 'Dokument speichern'
        @real_estate.reload
      }.to_not change { @real_estate.documents.count }

      page.should have_content "Datei muss vom Typ pdf sein"
    end

    it "doesn't create document without file attached"

  end


  describe "#edit" do
    before do
      @document = Fabricate.build :media_assets_document
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :documents => [@document]
    end

    it 'displays a preview of the document' do
      visit edit_cms_real_estate_document_path(@real_estate, @document)
      page.should have_css('.well a', :count => 1)
    end

    it 'updates the title' do
      visit edit_cms_real_estate_document_path(@real_estate, @document)

      fill_in 'Titel', :with => 'The updated Title'
      expect {
        click_on 'Dokument speichern'
      }.to change { @document.reload.title }
    end

    it "doesn't update if title is empty" do
      visit edit_cms_real_estate_document_path(@real_estate, @document)

      fill_in 'Titel', :with => ''
      expect {
        click_on 'Dokument speichern'
      }.to_not change { @document.reload.title }

      page.should have_content "Titel muss ausgefüllt werden"
    end

    it "doesn't update if document type isn't allowed" do
      visit edit_cms_real_estate_document_path(@real_estate, @document)

      attach_file 'Datei', "#{Rails.root}/spec/support/test_files/image.jpg"
      expect {
        click_on 'Dokument speichern'
      }.to_not change { @document.reload.updated_at }

      page.should have_content "Datei muss vom Typ pdf sein"
    end
  end


  describe "#show" do
    before do
      @document = Fabricate.build :media_assets_document
      @real_estate = Fabricate :published_real_estate, :category => Fabricate(:category), :documents => [@document]
    end

    it 'shows the title' do
      visit cms_real_estate_document_path(@real_estate, @document)
      page.should have_content @document.title
    end

    it 'shows a download link' do
      visit cms_real_estate_document_path(@real_estate, @document)
      page.should have_css ".well a[href='#{@document.file.url}']"
    end
  end


  describe "#destroy" do
    before do
      @document = Fabricate.build :media_assets_document
      @real_estate = Fabricate :real_estate, :category => Fabricate(:category), :documents => [@document]
    end

    it 'destroys the document' do
      visit cms_real_estate_media_assets_path(@real_estate)
      expect {
        click_on 'Löschen'
      }.to change { @real_estate.reload.documents.count }.by(-1)
    end
  end

end
