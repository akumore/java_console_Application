# encoding: utf-8
require 'spec_helper'

describe "Cms::Users" do
  login_cms_user

  describe '#index' do
    before :each do
      3.times{ Fabricate(:cms_user) }
      visit cms_users_path
    end

    it 'has a link to create a new user' do
      page.should have_link('Neuen Benutzer erfassen')
    end
    
    it 'has a list of the current users in the system' do
      page.should have_css('table tr', :count => Cms::User.count+1)
    end

    it 'has an edit link for a user' do
      within("#user-#{Cms::User.last.id}") do
        page.should have_link 'Editieren'
      end
    end

    it 'has a delete link for a user' do
      within("#user-#{Cms::User.last.id}") do
        page.should have_link 'Löschen'
      end
    end
  end

  describe '#new' do
    before :each do
      visit cms_users_path
      click_on 'Neuen Benutzer erfassen'
    end

    it 'opens the create form' do
      current_path.should == new_cms_user_path
    end
    
    describe '#create' do
      before :each do
        within "#new_cms_user" do
          fill_in 'E-Mail', :with => 'benutzername@test.ch'
          fill_in 'Passwort', :with => '123456'
          fill_in 'Passwort Bestätigung', :with => '123456'
          select 'Admin', :from => 'Rolle'
        end
      end

      it 'saves a new user' do
        lambda {
          click_on 'Benutzer erstellen'
        }.should change(Cms::User, :count).by(1)
      end

      describe 'allows the user to sign in to the cms' do
        before :each do
          click_on 'Benutzer erstellen'
          click_on 'Logout'
          visit cms_dashboards_path

          within('#user_new') do
            fill_in 'E-Mail', :with => 'benutzername@test.ch'
            fill_in 'Passwort', :with => '123456'
          end
          
          click_on 'Sign in'
        end

        it 'redirects to the dashboard' do
          current_path.should == cms_dashboards_path
        end
      end
    end
  end

  describe '#edit' do
    before :each do
      @user = Fabricate(:cms_user, :password => 'abcdefg', :password_confirmation => 'abcdefg')
      visit edit_cms_user_path(@user)
    end

    it 'opens the edit form' do
      current_path.should == edit_cms_user_path(@user)
    end

    describe '#update with passwords' do
      before :each do
        within ".edit_cms_user" do
          fill_in 'E-Mail', :with => 'hans@test.ch'
          select 'Editor', :from => 'Rolle'
        end

        click_on 'Benutzer speichern'
      end

      it 'updates the user' do
        @user.reload
        @user.email.should == 'hans@test.ch'
        @user.role.should == 'editor'
      end

      describe 'allows the user to sign in to the cms' do
        before :each do
          click_on 'Logout'
          visit cms_dashboards_path

          within('#user_new') do
            fill_in 'E-Mail', :with => 'hans@test.ch'
            fill_in 'Passwort', :with => 'abcdefg'
          end

          click_on 'Sign in'
        end

        it 'redirects to the dashboard' do
          current_path.should == cms_dashboards_path
        end
      end

    end
  end
end