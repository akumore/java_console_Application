require 'spec_helper'

describe "Authenticate Cms::User" do
  before :each do
    @user = Fabricate(:cms_user, :password => '123456', :password_confirmation => '123456')
    visit cms_dashboards_path
    current_path.should == new_user_session_path
  end

  context 'log in existing user' do
    before :each do
      within("#user_new") do
        fill_in 'user_email', :with => @user.email
        fill_in 'user_password', :with => '123456'
        click_button 'Einloggen'
      end
    end

    it 'redirects to the dashboard' do
      current_path.should == cms_dashboards_path
    end

    context 'logout' do
      before :each do
        click_link 'Abmelden'
      end

      it 'redirects to root page' do
        current_path.should == root_path
      end
    end
  end

  context 'when user is invalid' do
    before :each do
      within("#user_new") do
        fill_in 'user_email', :with => 'test'
        fill_in 'user_password', :with => 'foobar'
      end
    end

    it 'renders login page' do
      click_button 'Einloggen'
      current_path.should == new_user_session_path
    end
  end
end
