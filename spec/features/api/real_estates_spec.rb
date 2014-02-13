# encoding: utf-8

require "spec_helper"

describe "api/real_estates.json" do
  before { ApplicationController.new.set_current_view_context }

  let :microsite_reference do
    Fabricate.build(:microsite_reference,
                    :property_key => '22.34',
                    :building_key => 'H'
                   )
  end

  let :real_estate do
    Fabricate :published_real_estate,
              :category => Fabricate(:category, :label => 'Wohnung'),
              :channels => [RealEstate::MICROSITE_CHANNEL],
              :microsite_building_project => MicrositeBuildingProject::GARTENSTADT,
              :address => Fabricate.build(:address),
              :microsite_reference => microsite_reference,
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :contact => Fabricate(:employee)
  end

  describe 'visit api/realestates.json' do

    before :each do
      real_estate
      visit '/api/real_estates.json'
    end

    let :json_data do
      JSON.parse(page.source)
    end

    it 'returns one entry' do
      json_data.count.should == 1
    end

    describe 'data' do
      let :parsed_real_estate do
        json_data.first
      end

      it 'house delegates to building_key' do
        parsed_real_estate['house'].should == 'H'
      end

      it 'returns the property_key' do
        parsed_real_estate['property_key'].should == '22.34'
      end

      it 'returns the building_key' do
        parsed_real_estate['building_key'].should == 'H'
      end
    end
  end
end
