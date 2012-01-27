# encoding: utf-8
require 'spec_helper'

describe "Cms Information" do
  login_cms_user

  describe '#new' do
    before do
      @template_information = Fabricate.build(:information,
                                              :available_from=>Date.parse('2012-04-24'),
                                              :display_estimated_available_from=>'Ab Ende April',
                                              :has_isdn=>true,
                                              :number_of_restrooms=>10
      )
      @real_estate = Fabricate :real_estate
      visit new_cms_real_estate_information_path(@real_estate)
    end

    it 'creates a new information object' do
      select '24', :from=>'information_available_from_3i'
      select 'April', :from=>'information_available_from_2i'
      select '2012', :from=>'information_available_from_1i'
      fill_in 'Etwa verfügbar ab', :with=>@template_information.display_estimated_available_from
      fill_in "Anzahl WC's", :with=>@template_information.number_of_restrooms
      check 'ISDN-Anschluss'
      click_on 'Immobilieninfos erstellen'

      @real_estate.reload
      [:available_from, :display_estimated_available_from, :has_isdn, :number_of_restrooms].each do |method|
        @real_estate.information.send(method).should == @template_information.send(method)
      end
    end

    ["Anzahl WC's", "Max Gewicht Warenlift", "Maximale Bodenbelastung"].each do |target_field|

      it "fails to create because of invalid '#{target_field}' entered" do
        fill_in target_field, :with=>-9
        lambda {
          click_on 'Immobilieninfos erstellen'
          @real_estate.reload
        }.should_not change(@real_estate, :information)
      end

      it "doesn't fail to create on empty numerical field '#{target_field}'" do
        fill_in target_field, :with=>''
        lambda {
          click_on 'Immobilieninfos erstellen'
          @real_estate.reload
        }.should change(@real_estate, :information)
      end

    end
  end

end
