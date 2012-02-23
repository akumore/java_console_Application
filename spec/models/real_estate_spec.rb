require 'spec_helper'

describe RealEstate do
  describe '#row_house?' do
  	context 'with the category set to row_house' do
  		it 'is true' do
  			real_estate = Fabricate(:real_estate, :category => Fabricate(:category, :label => 'Reihenfamilienhaus', :name => 'row_house'))
  			real_estate.row_house?.should be_true
  		end
  	end

  	context 'with the category set to flat' do
  		it 'is false' do
  			real_estate = Fabricate(:real_estate, :category => Fabricate(:category, :label => 'Wohnung', :name => 'flat'))
  			real_estate.row_house?.should be_false
  		end
  	end

  	context 'without a category' do
  		it 'does not raise an error' do
  			real_estate = Fabricate(:real_estate)
  			expect { real_estate.row_house? }.to_not raise_error
  		end
  	end
  end

  describe 'top_level_category' do
    before do
      @toplevel_category = Fabricate.build :category
      @second_level_category = Fabricate.build :category, :parent=>@toplevel_category
      @real_estate = Fabricate.build :real_estate
    end

    it "returns the parent category of it's category" do
      @real_estate.category = @second_level_category
      @real_estate.top_level_category.should == @toplevel_category
    end
  end

  it "returns real estates published as reference project only" do
    Fabricate :real_estate, :channels => [RealEstate::WEBSITE_CHANNEL]
    reference_project = Fabricate :real_estate, :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL, RealEstate::WEBSITE_CHANNEL]

    RealEstate.reference_projects.all.should == [reference_project]
  end


end
