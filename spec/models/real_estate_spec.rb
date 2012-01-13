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
end
