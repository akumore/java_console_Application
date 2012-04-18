# encoding: utf-8
require 'spec_helper'

describe "Cms::Users" do
  context 'as an admin' do
    login_cms_admin

    context 'with real estates to be reviewed' do
      before :each do
        time_travel_to(2.hours.ago) do
          2.times do
            Fabricate(:real_estate,
              :category => Fabricate(:category),
              :reference => Fabricate.build(:reference),
              :state => RealEstate::STATE_IN_REVIEW
            )
          end
        end

        visit cms_dashboards_path
      end

      it 'shows a flash notice' do
        within('#flash') do
          page.should have_content "2 Immobilien warten darauf, überprüft zu werden."
        end
      end
    end

    context 'without real estates to be reviewed' do
      before :each do
        time_travel_to(24.hours.ago) do
          Fabricate(:real_estate,
            :category => Fabricate(:category),
            :reference => Fabricate.build(:reference),
            :state => RealEstate::STATE_IN_REVIEW
          )
        end

        visit cms_dashboards_path
      end

      it 'shows no flash notice' do
        find('#flash').text.should be_blank
      end
    end

    describe 'user info' do
      before do
        visit cms_dashboards_path
      end

      it 'shows the username for the current session' do
        page.should have_content "Eingeloggt als: #{@cms_user.email}"
      end

      it 'shows the user role for the current session' do
        page.should have_content "Rolle: Administrator"
      end

      it 'shows the logout link' do
        page.should have_content "Logout"
      end
    end
  end

  context 'as an edior' do
    login_cms_editor

    context 'with real estates to be reviewed' do
      before :each do
        time_travel_to(2.hours.ago) do
          2.times do
            Fabricate(:real_estate,
              :category => Fabricate(:category),
              :reference => Fabricate.build(:reference),
              :state => RealEstate::STATE_IN_REVIEW
            )
          end
        end

        visit cms_dashboards_path
      end

      it 'shows no flash notice' do
        find('#flash').text.should be_blank
      end
    end

    describe 'user info' do
      before do
        visit cms_dashboards_path
      end

      it 'shows the username for the current session' do
        page.should have_content "Eingeloggt als: #{@cms_user.email}"
      end

      it 'shows the user role for the current session' do
        page.should have_content "Rolle: Editor"
      end

      it 'shows the logout link' do
        page.should have_content "Logout"
      end
    end
  end

  describe '#show' do
    login_cms_user

    before do
      @header_row = 1
    end

    describe 'user info' do
      before do
        visit cms_dashboards_path
      end

      it 'has a link to the live page' do
        page.should have_link root_path
      end
    end

    it 'lists the latest real estates to be reviewed' do
      3.times do
        Fabricate(:real_estate,
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference),
          :state => RealEstate::STATE_IN_REVIEW
        )
      end

      visit cms_dashboards_path

      page.should have_css("table.in_review_state tr", :count => 3 + @header_row)
    end

    it 'lists the last 5 published real estates' do
      10.times do
        Fabricate(:real_estate,
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference),
          :state => RealEstate::STATE_PUBLISHED
        )
      end

      visit cms_dashboards_path

      page.should have_css("table.published_state tr", :count => 5 + @header_row)
    end

    it 'lists the last 5 edited real estates' do
      10.times do
        Fabricate(:real_estate,
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference),
          :state => RealEstate::STATE_EDITING
        )
      end

      visit cms_dashboards_path

      page.should have_css("table.editing_state tr", :count => 5 + @header_row)
    end
  end
end
