# encoding: utf-8

require 'active_support/all'
require 'microsite/group_real_estate'

module Microsite
  describe GroupRealEstates do

    let :private_real_estate do
      stub(
        :private_utilization? => true,
        :commercial_utilization? => false,
        :category_label => nil,
        :storing? => false
      )
    end

    let :commercial_real_estate do
      stub(:commercial_utilization? => true)
    end

    let :storing_real_estate do
      stub(
        :category_label => 'Disponibel',
        :commercial_utilization? => false,
        :storing? => true
      )
    end

    context 'as uncategorized real estate for private use' do
      it 'returns the value of \'rooms\' attribute as grouping key' do
        private_real_estate.stub(:figure => stub(:rooms => '3.5'))
        GroupRealEstates.get_group(private_real_estate)[:label].should == '3.5 Zimmer'
      end

      context 'rooms are set to \'0\'' do
        it 'returns \'Wohnatelier\' as grouping key' do
          private_real_estate.stub(:figure => stub(:rooms => '0'))
          GroupRealEstates.get_group(private_real_estate)[:label].should == 'Wohnatelier'
        end
      end
    end

    context 'with category_name \'Loft\'' do
      it 'returns \'Loft\' as grouping key' do
        private_real_estate.stub(:category_label => 'Loft')
        GroupRealEstates.get_group(private_real_estate)[:label].should == 'Loft'
      end
    end

    context 'as commercial building' do
      it 'returns \'Dienstleistungsflächen\' as grouping key' do
        GroupRealEstates.get_group(commercial_real_estate)[:label].should == 'Dienstleistungsflächen'
      end
    end

    context 'as storing building' do
      it 'returns the category name as grouping key' do
        GroupRealEstates.get_group(storing_real_estate)[:label].should == 'Disponibel'
      end
    end

    context 'grouping' do
      it 'sorts the objects in the order: number of rooms, Loft, Dienstleistungsflächen' do
        sort_keys = []
        private_real_estate.stub(:figure => stub(:rooms => '0'))
        sort_keys << GroupRealEstates.get_group(private_real_estate)[:sort_key]
        private_real_estate.stub(:figure => stub(:rooms => '1.5'))
        sort_keys << GroupRealEstates.get_group(private_real_estate)[:sort_key]
        private_real_estate.stub(:figure => stub(:rooms => '3.5'))
        sort_keys << GroupRealEstates.get_group(private_real_estate)[:sort_key]
        private_real_estate.stub(:category_label => 'Loft')
        sort_keys << GroupRealEstates.get_group(commercial_real_estate)[:sort_key]
        sort_keys << GroupRealEstates.get_group(storing_real_estate)[:sort_key]
        sort_keys << GroupRealEstates.get_group(private_real_estate)[:sort_key]
        sort_keys.sort.should == [ '1.5', '3.5', 'A', 'B', 'C', 'D' ]
      end
    end

  end
end

