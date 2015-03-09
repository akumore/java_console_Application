# encoding: utf-8

require 'spec_helper'

describe RealEstatesHelper do

  describe '#autorized_real_estates' do
    context 'local request' do
      it 'return all realestates' do
        should_receive(:request).and_return(double('request', 'local?' => true))
        expect(accessible_real_estates).to eq(RealEstate)
      end
    end

    context 'signed in request' do
      it 'return all realestates' do
        should_receive(:request).twice.and_return(double('request', 'local?' => false, remote_ip: ''))
        should_receive(:user_signed_in?).and_return(true)
        expect(accessible_real_estates).to eq(RealEstate)
      end
    end

    context 'public request' do
      it 'return all realestates' do
        should_receive(:request).twice.and_return(double('request', 'local?' => false, remote_ip: ''))
        should_receive(:user_signed_in?).and_return(false)
        expect(accessible_real_estates).not_to eq(RealEstate)
      end
    end
  end

  describe '#caption_css_class_for_text' do
    context 'with a long text' do
      it 'has the long shard image' do
        caption_css_class_for_text('a'*50).should == 'flex-caption wide'
      end
    end

    context 'with a short text' do
      it 'has the default shard image' do
        caption_css_class_for_text('a'*25).should == 'flex-caption'
      end
    end
  end

  describe '#microsite_select_options' do
    it 'returns the translated microsite options' do
      expected_arr = [
        ["Gartenstadt-Schlieren", "gartenstadt"], 
        ["Feldpark", "feldpark"], 
        ["Bünzpark", "buenzpark"]
      ]

      microsite_select_options.should == expected_arr
    end
  end

  describe '#category_options_for_utilization' do
    before do
      Fabricate :category, id: 1, name: 'single_house', label: 'Einfamilienhaus', utilization: Utilization::LIVING, utilization_sort_order: 1
      Fabricate :category, id: 2, name: 'flat', label: 'Wohnung', utilization: Utilization::LIVING, utilization_sort_order: 2
      Fabricate :category, id: 3, name: 'studio', label: 'Studio', utilization: Utilization::WORKING
    end

    it 'returns the category select options with category name data attribute' do
      expected_arr = [
        ['Einfamilienhaus', 1, { 'data-category_name' => 'single_house' }], 
        ['Wohnung', 2, { 'data-category_name' => 'flat' }]
      ]
      expect(category_options_for_utilization(Utilization::LIVING)).to eq(expected_arr)
    end
  end
end
