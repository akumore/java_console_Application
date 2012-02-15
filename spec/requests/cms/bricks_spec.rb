# encoding: utf-8
require 'spec_helper'

describe "Cms::Bricks" do
  login_cms_user

  before do
    @page = Fabricate(:page)
    @page.bricks << Fabricate.build(:title_brick)
    @page.bricks << Fabricate.build(:text_brick)
    @page.bricks << Fabricate.build(:placeholder_brick)
    @page.bricks << Fabricate.build(:accordion_brick)
    @page.reload

    @title_brick = @page.bricks[0]
    @text_brick = @page.bricks[1]
    @placeholder_brick = @page.bricks[2]
    @accordion_brick = @page.bricks[3]

    visit edit_cms_page_path(@page)
  end

  describe '#index' do
    it "shows the list of bricks" do
      page.should have_selector('.bricks-table tr', :count => @page.bricks.count+1)
    end

    it "takes me to the edit page of a title brick" do
      within("tr.title") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_page_title_brick_path(@page, @title_brick)
    end

    it "takes me to the edit page of a text brick" do
      within("tr.text") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_page_text_brick_path(@page, @text_brick)
    end

    it "takes me to the edit page of a accordion brick" do
      within("tr.accordion") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_page_accordion_brick_path(@page, @accordion_brick)
    end

    it "takes me to the edit page of a placeholder brick" do
      within("tr.placeholder") do
        page.click_link 'Editieren'
      end
      current_path.should == edit_cms_page_placeholder_brick_path(@page, @placeholder_brick)
    end
  end

  context 'title brick' do
    describe '#new' do
      before :each do
        visit new_cms_page_title_brick_path(@page)
      end

      context 'creating' do
        before :each do
          within('.new_brick_title') do
            fill_in 'Titel', :with => 'Mein Titel'
          end
        end

        it 'has saved the provided attributes' do
          click_on 'Titel Baustein erstellen'
          @page.reload
          @brick = @page.bricks.last
          @brick.title.should == 'Mein Titel'
        end
      end
    end

    describe '#edit' do
      before :each do
        visit edit_cms_page_title_brick_path(@page, @title_brick)
      end

      context 'updating ' do
        before :each do
          within('.edit_brick_title') do
            fill_in 'Titel', :with => 'Anderer Titel'
          end
        end

        it 'has updated the edited attributes' do
          click_on 'Titel Baustein speichern'
          @page.reload
          @brick = @page.bricks.find(@title_brick.id)
          @brick.title.should == 'Anderer Titel'
        end
      end
    end
  end

  context 'text brick' do
    describe '#new' do
      before :each do
        visit new_cms_page_text_brick_path(@page)
      end

      context 'creating' do
        before :each do
          within('.new_brick_text') do
            fill_in 'Text', :with => 'Mein Text'
            fill_in 'Mehr lesen Text', :with => 'Mein mehr lesen Text'
          end
        end

        it 'has saved the provided attributes' do
          click_on 'Text Baustein erstellen'
          @page.reload
          @brick = @page.bricks.last
          @brick.text.should == 'Mein Text'
          @brick.more_text.should == 'Mein mehr lesen Text'
        end
      end
    end

    describe '#edit' do
      before :each do
        visit edit_cms_page_text_brick_path(@page, @text_brick)
      end

      context 'updating ' do
        before :each do
          within('.edit_brick_text') do
            fill_in 'Text', :with => 'Anderer Text'
            fill_in 'Mehr lesen Text', :with => 'Anderer mehr lesen Text'
          end
        end

        it 'has updated the edited attributes' do
          click_on 'Text Baustein speichern'
          @page.reload
          @brick = @page.bricks.find(@text_brick.id)
          @brick.text.should == 'Anderer Text'
          @brick.more_text.should == 'Anderer mehr lesen Text'
        end
      end
    end
  end

  context 'accordion brick' do
    describe '#new' do
      before :each do
        visit new_cms_page_accordion_brick_path(@page)
      end

      context 'creating' do
        before :each do
          within('.new_brick_accordion') do
            fill_in 'Titel', :with => 'Mein Titel'
            fill_in 'Text', :with => 'Mein Text'
          end
        end

        it 'has saved the provided attributes' do
          click_on 'Akkordeon Baustein erstellen'
          @page.reload
          @brick = @page.bricks.last
          @brick.title.should == 'Mein Titel'
          @brick.text.should == 'Mein Text'
        end
      end
    end

    describe '#edit' do
      before :each do
        visit edit_cms_page_accordion_brick_path(@page, @accordion_brick)
      end

      context 'updating ' do
        before :each do
          within('.edit_brick_accordion') do
            fill_in 'Titel', :with => 'Anderer Titel'
            fill_in 'Text', :with => 'Anderer Text'
          end
        end

        it 'has updated the edited attributes' do
          click_on 'Akkordeon Baustein speichern'
          @page.reload
          @brick = @page.bricks.find(@accordion_brick.id)
          @brick.title.should == 'Anderer Titel'
          @brick.text.should == 'Anderer Text'
        end
      end
    end
  end

  context 'placeholder brick' do
    describe '#new' do
      before :each do
        visit new_cms_page_placeholder_brick_path(@page)
      end

      context 'creating' do
        before :each do
          within('.new_brick_placeholder') do
            select 'Jobs: Erfolgreich bewerben', :from => 'Platzhalter'
          end
        end

        it 'has saved the provided attributes' do
          click_on 'Platzhalter Baustein erstellen'
          @page.reload
          @brick = @page.bricks.last
          @brick.placeholder.should == 'jobs_apply_with_success'
        end
      end
    end

    describe '#edit' do
      before :each do
        visit edit_cms_page_placeholder_brick_path(@page, @placeholder_brick)
      end

      context 'updating ' do
        before :each do
          within('.edit_brick_placeholder') do
            select 'Jobs: Offene Stellen', :from => 'Platzhalter'
          end
        end

        it 'has updated the edited attributes' do
          click_on 'Platzhalter Baustein speichern'
          @page.reload
          @brick = @page.bricks.find(@placeholder_brick.id)
          @brick.placeholder.should == 'jobs_openings'
        end
      end
    end
  end

  describe '#destroy' do
    it "destroys the title brick" do
      pending 'figure out why this does not work'
      lambda {
        within("tr.title") do
          page.click_link 'Löschen'
        end
        @page.reload
      }.should change(@page.bricks, :count).by(-1)
    end

    it "destroys the text brick" do
      pending 'figure out why this does not work'
      lambda {
        within("tr.text") do
          page.click_link 'Löschen'
        end
        @page.reload
      }.should change(@page.bricks, :count).by(-1)
    end

    it "destroys the accordion brick" do
      pending 'figure out why this does not work'
      lambda {
        within("tr.accordion") do
          page.click_link 'Löschen'
        end
        @page.reload
      }.should change(@page.bricks, :count).by(-1)
    end

    it "destroys the placeholder brick" do
      pending 'figure out why this does not work'
      lambda {
        within("tr.placeholder") do
          page.click_link 'Löschen'
        end
        @page.reload
      }.should change(@page.bricks, :count).by(-1)
    end
  end
end
