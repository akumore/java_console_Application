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
          fill_in 'Anzahl Parkplätze in Autoeinstellhalle', :with => '1'
          fill_in 'Anzahl Parkplätze im Freien', :with => '2'
          fill_in 'Anzahl Parkplätze im Freien überdacht', :with => '3'
          fill_in 'Anzahl Motorrad-Parkplätze in Autoeinstellhalle', :with => '4'
          fill_in 'Anzahl Motorrad-Parkplätze im Freien überdacht', :with => '5'
          fill_in 'Anzahl Einzelgaragen', :with => '6'
          fill_in 'Anzahl Doppelgaragen', :with => '7'

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
          @infrastructure.inside_parking_spots.should == 1
          @infrastructure.outside_parking_spots.should == 2
          @infrastructure.covered_slot.should == 3
          @infrastructure.covered_bike.should == 4
          @infrastructure.outdoor_bike.should == 5
          @infrastructure.single_garage.should == 6
          @infrastructure.double_garage.should == 7
        end

        it 'has addded two points of interest' do
          @infrastructure.points_of_interest.length.should == 2
        end
      end
    end
  end

  describe '#show' do
    let :real_estate do
      Fabricate :real_estate, :category => Fabricate(:category), :infrastructure => Fabricate.build(:infrastructure)
    end

    let :real_estate_without_infrastructure do
      Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'shows the infrastructure within the cms' do
      visit cms_real_estate_infrastructure_path real_estate
      [:has_parking_spot,:has_garage].each do |attr|
        page.should have_content I18n.t("#{real_estate.infrastructure.send(attr)}")
      end
    end

    it 'shows a message if no infrastructure exist' do
      visit cms_real_estate_infrastructure_path real_estate_without_infrastructure
      page.should have_content "Für diese Immobilie wurde keine Infrastruktur hinterlegt."
    end
  end
end
