# encoding: utf-8
require "spec_helper"

describe "Floorplans for printing" do
  monkey_patch_default_url_options

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
              :infrastructure => Fabricate.build(:infrastructure),
              :additional_description => Fabricate.build(:additional_description),
              :floor_plans => [Fabricate.build(:media_assets_floor_plan), Fabricate.build(:media_assets_floor_plan)],
              :contact => Fabricate(:employee)
  end

  describe "all floorplans" do
    before do
      visit real_estate_floorplans_path(real_estate)
    end

    it 'shows all floorplans' do
      page.should have_css('img', :count => 2)
    end

    it 'opens the print dialogue' do
      page.should have_content('window.print')
    end
  end
end
