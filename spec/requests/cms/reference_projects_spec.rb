# encoding: utf-8
require 'spec_helper'

describe "Cms::ReferenceProject" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:reference_project) }
      3.times { Fabricate(:reference_project, :locale => 'fr') }
      visit cms_reference_projects_path
    end

    describe 'language tabs' do
      it 'shows a tab for every content language' do
        I18n.available_locales.each do |locale|
          page.should have_link(I18n.t("languages.#{locale}"))
        end
      end

      it 'has the DE tab activated by default' do
        page.should have_css('li.active:contains(DE)')
      end

      it 'selects the tab according to the content langauge' do
        visit cms_reference_projects_path(:content_language => :fr)
        page.should have_css('li.active:contains(FR)')
      end
    end

    it "has a title" do
      page.should have_css('h1', :text => 'Erfasste Referenzprojekte')
    end

    it "shows the list of reference projects for the current content locale" do
      page.should have_selector('table tr', :count => ReferenceProject.where(:locale => :de).count + 1)
    end

    it "takes me to the edit page of a reference_project" do
      reference_project = ReferenceProject.where(:locale => :de).last
      within("#reference_project_#{reference_project.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_reference_project_path(reference_project.id)
    end

    it "takes me to the page for creating a new reference project" do
      page.click_link 'Neues Referenzprojekt erstellen'
      current_path.should == new_cms_reference_project_path
    end

  end

  describe 'order' do
    before do
      @third = Fabricate(:reference_project, :position => 3)
      @first = Fabricate(:reference_project, :position => 1)
      @second = Fabricate(:reference_project, :position => 2)
      visit cms_reference_projects_path
    end

    it "displays the reference projects in the right sort order" do
      page.all(:css, '.reference-projects .reference-project .title').map(&:text).should == ReferenceProject.all.map(&:title)
    end
  end

  describe 'new' do
    it "renders the complete form" do
      visit new_cms_reference_project_path
      page.should have_css('input[name="reference_project[title]"]')
      page.should have_css('input[name="reference_project[url]"]')
      page.should have_css('textarea[name="reference_project[description]"]')
      page.should have_css('input[name="reference_project[locale]"]')
      page.should have_css('select[name="reference_project[real_estate_id]"]')
    end
  end

  describe 'create' do
    it "renders the complete form" do
      visit new_cms_reference_project_path
      fill_in('reference_project_title', :with => 'Neues Referenzprojekt')
      fill_in('reference_project_description', :with => 'Projektbeschreibung')
      fill_in('reference_project_url', :with => 'http://www.projekt.com')
      attach_file('reference_project_image', "#{Rails.root}/spec/support/test_files/image.jpg")
      click_button 'Referenzprojekt erstellen'
      ReferenceProject.where(:title => 'Neues Referenzprojekt').count.should == 1
    end
  end
end
