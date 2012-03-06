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
              :state => :in_review
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
            :state => :in_review
          )
        end

        visit cms_dashboards_path
      end

      it 'shows no flash notice' do
        find('#flash').text.should be_blank
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
              :state => :in_review
            )
          end
        end

        visit cms_dashboards_path
      end

      it 'shows no flash notice' do
        find('#flash').text.should be_blank
      end
    end
  end
end