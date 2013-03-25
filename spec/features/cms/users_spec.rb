# encoding: utf-8
require 'spec_helper'

describe "Cms::Users" do
  context 'as an admin' do
    login_cms_admin

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
            fill_in 'cms_user_first_name', :with => 'Benutzer'
            fill_in 'cms_user_last_name', :with => 'Name'
            fill_in 'cms_user_email', :with => 'benutzername@test.ch'
            fill_in 'cms_user_password', :with => '123456'
            fill_in 'cms_user_password_confirmation', :with => '123456'
            select 'Admin', :from => 'cms_user_role'
            check 'cms_user_wants_review_emails'
          end
        end

        it 'saves a new user' do
          lambda {
            click_on 'Benutzer erstellen'
          }.should change(Cms::User, :count).by(1)
        end

        it 'redirects to the user list' do
          click_on 'Benutzer erstellen'
          current_path.should == cms_users_path
        end

        it 'shows a success message' do
          click_on 'Benutzer erstellen'
          within('#flash') do
            page.should have_content 'Der Benutzer benutzername@test.ch wurde erfolgreich gespeichert'
          end
        end

        describe 'allows the user to sign in to the cms' do
          before :each do
            click_on 'Benutzer erstellen'
            click_on 'Abmelden'
            visit cms_dashboards_path

            within('#user_new') do
              fill_in 'E-Mail', :with => 'benutzername@test.ch'
              fill_in 'Passwort', :with => '123456'
            end

            click_on 'Einloggen'
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

        it 'redirects to the user list' do
          current_path.should == cms_users_path
        end

        it 'shows a success message' do
          within('#flash') do
            page.should have_content 'Der Benutzer hans@test.ch wurde erfolgreich gespeichert'
          end
        end

        describe 'allows the user to sign in to the cms' do
          before :each do
            click_on 'Abmelden'
            visit cms_dashboards_path

            within('#user_new') do
              fill_in 'E-Mail', :with => 'hans@test.ch'
              fill_in 'Passwort', :with => 'abcdefg'
            end

            click_on 'Einloggen'
          end

          it 'redirects to the dashboard' do
            current_path.should == cms_dashboards_path
          end
        end

      end
    end

    it "destroys the cms user" do
      other_user = Fabricate :cms_admin
      visit cms_users_path

      within "#user-#{other_user.id}" do
        expect {
          click_link 'Löschen'
        }.should change(Cms::User, :count).by(-1)
      end
      current_path.should == cms_users_path
      page.should have_content "Der Benutzer #{other_user.email} wurde erfolgreich gelöscht"
    end

  end

  context 'as an editor' do
    login_cms_editor

    describe '#index' do
      before :each do
        3.times{ Fabricate(:cms_user) }
        visit cms_users_path
      end

      it 'does not have a link to create a new user' do
        page.should_not have_link('Neuen Benutzer erfassen')
      end

      it 'has a list of the current users in the system' do
        page.should have_css('table tr', :count => Cms::User.count+1)
      end

      it 'does not have an edit link for a user' do
        within("#user-#{Cms::User.last.id}") do
          page.should_not have_link 'Löschen'
        end
      end

      it 'does not have a delete link for a user' do
        within("#user-#{Cms::User.last.id}") do
          page.should_not have_link 'Löschen'
        end
      end
    end

    describe '#new' do
      it 'redirects to the dashboard with a flash message' do
        visit new_cms_user_path
        current_path.should == cms_dashboards_path
        find('#flash').should have_content 'Sie haben keine Berechtigungen für diese Aktion'
      end
    end

    describe '#edit' do
      it 'redirects to the dashboard with a flash message' do
        visit edit_cms_user_path(Fabricate(:cms_user))
        current_path.should == cms_dashboards_path
        find('#flash').should have_content 'Sie haben keine Berechtigungen für diese Aktion'
      end
    end

    it "has no link for destroying an cms user" do
      visit cms_users_path
      within "#user-#{@cms_user.id}" do
        page.should_not have_link "Löschen"
      end
    end

  end
end
