# encoding: utf-8
require 'spec_helper'

describe "Cms::Infrastructures" do
  login_cms_user
  create_category_tree

  describe '#new' do
    before :each do
      @real_estate = Fabricate(:real_estate,
        :category => Category.last, 
        :reference => Fabricate.build(:reference)
      )
      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Infrastruktur'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_infrastructure_path(@real_estate)
    end

    context 'a valid Infrastructure' do
      before :each do
        within(".new_infrastructure") do
          check 'Hat Parkplatz'
          check 'Hat überdachten Parkplatz'
          check 'Hat Garage'

          fill_in 'Anzahl Parkplätze im Freien', :with => '2'
          fill_in 'Anzahl Parkplätze in Autoeinstellhalle', :with => '1'

          fill_in 'Anzahl temporäre Parkplätze im Freien', :with => '1'
          fill_in 'Anzahl temporäre Parkplätze in Autoeinstellhalle', :with => '1'

          fill_in 'Öffentlicher Verkehr', :with => '200'
          fill_in 'Einkaufen', :with => '100'
        end
      end

      it 'saves a new Infrastructure' do
        click_on 'Infrastruktur erstellen'
        @real_estate.reload
        @real_estate.infrastructure.should be_a(Infrastructure)
      end

      context '#create' do
        before :each do
          click_on 'Infrastruktur erstellen'
          @real_estate.reload
          @infrastructure = @real_estate.infrastructure
        end

        it 'has saved the provided attributes' do
          @infrastructure.has_parking_spot.should be_true
          @infrastructure.has_roofed_parking_spot.should be_true
          @infrastructure.has_garage.should be_true
          @infrastructure.outside_parking_spots.should == 2
          @infrastructure.inside_parking_spots.should == 1
          @infrastructure.outside_parking_spots_temporary.should == 1
          @infrastructure.inside_parking_spots_temporary.should == 1
        end

        it 'has addded two points of interest' do
          @infrastructure.points_of_interest.length.should == 2
        end
      end
    end
  end
end
