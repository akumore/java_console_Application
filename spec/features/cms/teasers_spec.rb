# encoding: utf-8
require 'spec_helper'

describe "Cms::Teasers" do
  login_cms_user

  describe '#index' do
    before do
      3.times { Fabricate(:teaser) }
      3.times { Fabricate(:teaser, :locale => :fr) }
      @teaser = Teaser.first
      visit cms_teasers_path
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
        visit cms_jobs_path(:content_language => :fr)
        page.should have_css('li.active:contains(FR)')
      end
    end

    it "shows the list of teasers for the current content locale" do
      page.should have_selector('table tr', count: Teaser.where(:locale => :de).count+1)
    end

    it "takes me to the edit page of a teaser" do
      within("#teaser_#{@teaser.id}") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_teaser_path(@teaser)
    end

    it "takes me to the page for creating a new teaser" do
      page.click_link 'Neuen Teaser erstellen'
      current_path.should == new_cms_teaser_path
    end
  end

  describe '#new' do
    before :each do
      visit new_cms_teaser_path(:content_locale => :fr)
    end

    it 'opens the create form' do
      current_path.should == new_cms_teaser_path
    end

    it 'informs of the current content locale in the title' do
      page.should have_content('Neuen Teaser in Französisch anlegen')
    end

    it 'prefills the selected language' do
      page.should have_css('input#teaser_locale[value=fr]')
    end

    context 'a valid Teaser' do
      before :each do
        within(".new_teaser") do
          fill_in 'Titel', with: 'Ein schöner Teaser'
          fill_in 'Link Text', with: 'Geh auf diese Seite'
          fill_in 'Link', with: '/'
        end
      end

      it 'save a new Teaser' do
        lambda do
          click_on 'Teaser erstellen'
        end.should change(Teaser, :count).from(0).to(1)
      end

      context '#create' do
        before :each do
          click_on 'Teaser erstellen'
          @teaser = Teaser.last
        end

        it 'has saved the provided attributes' do
          @teaser.title.should == 'Ein schöner Teaser'
          @teaser.link.should == 'Geh auf diese Seit'
          @teaser.href.should '/'
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @job = Fabricate(:teaser)
      visit edit_cms_teaser_path(@teaser)
    end

    it 'opens the edit form' do
      current_path.should === edit_cms_teaser_path(@teaser)
    end

    context '#update' do
      before :each do
        within(".edit_teaser") do
          fill_in 'Titel', with: 'Titel Updated'
          fill_in 'Link Text', with: 'Link Updated'
          fill_in 'Link', with: '/fr'
        end

        click_on 'Teaser speichern'
      end

      it 'has updated the edited attributes' do
        @teaser.reload
        @teaser.title.should == 'Titel updated'
        @teaser.link.should == 'Link updated'
        @teaser.href.should == '/fr'
      end
    end
  end

  describe '#destroy' do
    before :each do
      @teaser = Fabricate(:teaser)
      visit cms_teasers_path
    end

    it 'deletes the teaser' do
      lambda {
        within("#teaser_#{@teaser.id}") do
          click_link 'Löschen'
        end
      }.should change(Teaser, :count).by(-1)
    end
  end
end
