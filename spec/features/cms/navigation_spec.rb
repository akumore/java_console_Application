# encoding: utf-8
require 'spec_helper'

describe "Cms Navigation" do

  shared_examples_for "navigation menu for all user roles" do
    it "links to the dashboard" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Dashboard", :href => cms_dashboards_path
      end
    end

    it "links to the real estate wizard" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Immobilien", :href => cms_real_estates_path
      end
    end

    it "links to the user administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Benutzer", :href => cms_users_path
      end
    end

    it 'shows the username for the current session' do
      visit cms_dashboards_path
      page.should have_content "Angemeldet als: #{@cms_user.email}"
    end

    it 'shows the user role for the current session' do
      visit cms_dashboards_path
      page.should have_content "Rolle: #{Cms::User.human_attribute_name("role_#{@cms_user.role}")}"
    end

    it 'shows the logout link' do
      visit cms_dashboards_path
      page.should have_link "Abmelden", :href => destroy_user_session_path
    end
  end


  context "As an admin" do
    login_cms_admin

    it_behaves_like "navigation menu for all user roles"

    it "links to the employees/contact persons administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Mitarbeiter", :href => cms_employees_path
      end
    end


    it "links to the news administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "News", :href => cms_news_items_path
      end
    end

    it "links to the jobs administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Jobs", :href => cms_jobs_path
      end
    end

    it "links to the pages administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should have_link "Seiten", :href => cms_pages_path
      end
    end
  end


  context "As an editor" do
    login_cms_editor

    it_behaves_like "navigation menu for all user roles"

    it "doesn't link to the employees/contact persons administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should_not have_link "Mitarbeiter", :href => cms_employees_path
      end
    end

    it "doesn't link to the news administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should_not have_link "News", :href => cms_news_items_path
      end
    end

    it "doesn't link to the jobs administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should_not have_link "Jobs", :href => cms_jobs_path
      end
    end

    it "doesn't link to the pages administration" do
      visit cms_dashboards_path
      within ".navbar" do
        page.should_not have_link "Seiten", :href => cms_pages_path
      end
    end
  end

end
