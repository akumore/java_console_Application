# encoding: utf-8

require 'active_support/all'
require 'group_microsite_real_estate'

describe GroupMicrositeRealEstates do

  let :private_real_estate do
    stub(
      :private_utilization? => true,
      :commercial_utilization? => false,
      :category_label => nil,
    )
  end

  let :commercial_real_estate do
    stub(:commercial_utilization? => true)
  end

  context 'as uncategorized real estate for private use' do
    it 'returns the value of \'rooms\' attribute as grouping key' do
      private_real_estate.stub(:figure => stub(:rooms => '3.5'))
      GroupMicrositeRealEstates.get_group(private_real_estate).should == '3.5 Zimmer Wohnungen'
    end
  end

  context 'with category_name \'Loft\'' do
    it 'returns \'Loft\' as grouping key' do
      private_real_estate.stub(:category_label => 'Loft')
      GroupMicrositeRealEstates.get_group(private_real_estate).should == 'Loft'
    end
  end

  context 'as commercial building' do
    it 'returns \'Dienstleistungsflächen\' as grouping key' do
      GroupMicrositeRealEstates.get_group(commercial_real_estate).should == 'Dienstleistungsflächen'
    end
  end

end

