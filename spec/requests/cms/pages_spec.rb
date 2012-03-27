# encoding: utf-8
require 'spec_helper'

describe "Cms::Pages" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:page) }
      3.times { Fabricate(:page, :locale => 'fr') }
      @page = Page.first
      visit cms_pages_path
    end

    describe 'language tabs' do
      it 'shows a tab for every content language' do
        I18n.available_locales.each do |locale|
          page.should have_link(locale.to_s.upcase)
        end
      end

      it 'has the DE tab activated by default' do
        page.should have_css('li.active:contains(DE)')
      end

      it 'selects the tab according to the content langauge' do
        visit cms_pages_path(:content_language => :fr)
        page.should have_css('li.active:contains(FR)')
      end
    end

    it "shows the list of pages for the current content locale" do
      page.should have_selector('table tr', :count => Page.where(:locale => :de).count + 1)
    end

    it "takes me to the edit page of a page" do
      within("#page_#{@page.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_page_path(@page)
    end

    it "takes me to the page for creating a new real estate" do
      page.click_link 'Neue Seite erstellen'
      current_path.should == new_cms_page_path
    end
  end

  describe '#new' do
    before :each do
      visit new_cms_page_path(:content_locale => :fr)
    end

    it 'opens the create form' do
      current_path.should == new_cms_page_path
    end

    it 'prefills the selected language' do
      page.should have_css('input#page_locale[value=fr]')
    end

    it 'displays the input for the unique name' do
      page.should have_css('input#page_name')
    end

    it 'does not display the dropdown to add new bricks' do
      page.should_not have_link('Baustein hinzufügen')
    end

    it 'does not display the list of bricks' do
      page.should_not have_css('.bricks-table')
    end

    context 'a valid Page' do
      before :each do
        within(".new_page") do
          fill_in 'Titel', :with => 'Seiten Titel'
          fill_in 'Eindeutiger Name', :with => 'seiten-titel'
        end
      end

      it 'save a new Page' do
        lambda do
          click_on 'Seite erstellen'
        end.should change(Page, :count).from(0).to(1)
      end

      context '#create' do
        before :each do
          click_on 'Seite erstellen'
          @page = Page.last
        end

        it 'has saved the provided attributes' do
          @page.title.should == 'Seiten Titel'
          @page.name.should == 'seiten-titel'
          @page.locale.should == 'fr'
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @page = Fabricate(:page)
      @unique_name = @page.name
      visit edit_cms_page_path(@page)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_page_path(@page)
    end

    it 'does not display the input for the unique name' do
      page.should_not have_content('Eindeutiger Name')
    end

    describe 'bricks' do
      it 'displays the dropdown to add new bricks' do
        page.should have_link('Baustein hinzufügen')
      end

      it 'has a link to create a new title brick' do
        page.should have_link('Titel Baustein')
      end

      it 'has a link to create a new text brick' do
        page.should have_link('Text Baustein')
      end

      it 'has a link to create a new accordion brick' do
        page.should have_link('Akkordeon Baustein')
      end

      it 'has a link to create a new placeholder brick' do
        page.should have_link('Platzhalter Baustein')
      end

      it 'displays the list of bricks' do
        page.should have_css('.bricks-table')
      end
    end

    context '#update' do
      before :each do
        within(".edit_page") do
          fill_in 'Titel', :with => 'Seiten Titel 2'
        end

        click_on 'Seite speichern'
      end

      it 'has updated the edited attributes' do
        @page.reload
        @page.title.should == 'Seiten Titel 2'
        @page.name.should == @unique_name
      end
    end
  end

  describe '#destroy' do
    before :each do
      @page = Fabricate(:page)
      visit cms_pages_path
    end

    it 'deletes the page' do
      lambda {
        within("#page_#{@page.id}") do
          click_link 'Löschen'
        end
      }.should change(Page, :count).by(-1)
    end
  end

end
