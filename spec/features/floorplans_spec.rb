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
              :additional_description => Fabricate.build(:additional_description, :orientation_degrees => 180),
              :floor_plans => [Fabricate.build(:media_assets_floor_plan), Fabricate.build(:media_assets_floor_plan)],
              :contact => Fabricate(:employee)
  end

  describe "all floorplans" do
    before do
      visit real_estate_floorplans_path(real_estate)
    end

    it 'shows all floorplans and one north arrow' do
      page.should have_css('img', :count => 3)
    end

    it 'does not open the print dialogue' do
      page.html.should_not have_content('window.print')
    end

    describe "with print parameter" do
      it 'opens the print dialogue' do
        visit real_estate_floorplans_path(real_estate, :print => true)
        page.html.should have_content('window.print')
      end
    end
  end
end
