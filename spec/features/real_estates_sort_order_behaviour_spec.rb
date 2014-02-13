# encoding: utf-8

require 'spec_helper'

describe 'Sort order behaviour' do
  monkey_patch_default_url_options

  let :category do
    Fabricate(:category, :label => 'Wohnung')
  end

  let :living_real_estate do
    Fabricate :published_real_estate,
              :utilization=>Utilization::LIVING,
              :category => category,
              :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
              :address => Fabricate.build(:address),
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :contact => Fabricate(:employee)
  end

  let :working_real_estate do
    Fabricate :published_real_estate,
              :utilization=>Utilization::WORKING,
              :category => category,
              :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
              :address => Fabricate.build(:address),
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :contact => Fabricate(:employee)
  end

  before do
    @real_estates = [living_real_estate, working_real_estate]
  end

  describe 'Default sort order params' do
    context "with utilization 'private'" do
      it "sets the default sort_field to 'usable surface'" do
        visit real_estates_path(:utilization => Utilization::LIVING, :offer => Offer::RENT)
        find_field('search_filter_sort_field').find('option[selected]').text.should == 'Zimmer'
      end
    end

    context "with utilization 'commercial'" do
      it "sets the default sort_field to 'rooms'" do
        visit real_estates_path(:utilization => Utilization::WORKING, :offer => Offer::RENT)
        find_field('search_filter_sort_field').find('option[selected]').text.should == 'm²'
      end
    end
  end

  describe 'Sort-ordering of real estates by sort_field' do
    before do
      visit real_estates_path(:utilization => Utilization::LIVING, :offer => Offer::RENT)
      select 'Preis', :from => 'search_filter_sort_field'
      click_button 'Suchen'
    end

    it 'filters by price' do
      find_field('search_filter_sort_field').find('option[selected]').text.should == 'Preis'
    end

    it 'sets the sort_field to price after switching back from show to index view' do
      find("tr[id=real-estate-#{living_real_estate.id}] a").click
      click_link 'Übersicht'
      find_field('search_filter_sort_field').find('option[selected]').text.should == 'Preis'
    end
  end
end
