# encoding: utf-8
require 'spec_helper'

describe 'Cms::Preview::RealEstates' do
  create_category_tree

  let :category do
    Fabricate(:category, :label => 'Wohnung')
  end

  let :real_estate do
    Fabricate :published_real_estate,
              :category => category,
              :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
              :address => Fabricate.build(:address),
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :additional_description => Fabricate.build(:additional_description),
              :contact => Fabricate(:employee)
  end

  let :unpublished_real_estate do
    Fabricate :real_estate,
              :category => category,
              :address => Fabricate.build(:address),
              :figure => Fabricate.build(:figure, :rooms => 20, :floor => 1),
              :pricing => Fabricate.build(:pricing),
              :contact => Fabricate(:employee)
  end

  describe 'preview in cms' do
    login_cms_user

    context 'with an unpublished real estate' do
      before do
        visit cms_real_estate_path(unpublished_real_estate)
      end

      it 'shows the preview button with the cms_preview_real_estate_path link' do
        page.should have_link 'Vorschau', :href => cms_preview_real_estate_path(unpublished_real_estate)
      end
    end

    context 'with a published real estate' do
      before do
        visit cms_real_estate_path(real_estate)
      end

      it 'shows the preview button with the real_estate_path link' do
        page.should have_link 'Vorschau', :href => real_estate_path(real_estate, :locale => I18n.locale)
      end
    end

    context 'with an unsaved real estate' do
      before do
        visit new_cms_real_estate_path
      end

      it 'shows the disabled preview button with no real estate link' do
        page.should_not have_link 'Vorschau', :href => '#'
        page.should_not have_css '.preview-button.btn.disabled'
      end
    end
  end

  describe 'preview in frontend' do
    login_cms_user

    before do
      visit cms_preview_real_estate_path(real_estate)
    end

    it 'shows the preview' do
      page.should have_css '.main-title', :text => real_estate.title
    end
  end
end

