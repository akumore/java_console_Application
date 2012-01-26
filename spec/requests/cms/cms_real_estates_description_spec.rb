# encoding: utf-8
require 'spec_helper'

describe "Cms::Descriptions" do
  login_cms_user
  create_category_tree

  describe '#new' do
    before :each do
      @real_estate = Fabricate(:real_estate,
        :category => Category.last, 
        :reference => Fabricate.build(:reference)
      )
      visit edit_cms_real_estate_path(@real_estate)
      click_on 'Beschreibungen'
    end

    it 'opens the create form' do
      current_path.should == new_cms_real_estate_description_path(@real_estate)
    end

    context 'a valid Description' do
      before :each do
        within(".new_description") do
          fill_in 'Immobilie', :with => 'Modernes Wohnen in schöner Landschaft'
          fill_in 'Standort', :with => 'In laufweite zum Flughafen'
          fill_in 'Ausbaustandard', :with => 'Top moderne Küche'
          fill_in 'Angebot', :with => 'Schöne Aussicht'
          fill_in 'Infrastruktur', :with => 'An bester Einkaufslage'
          fill_in 'Nutzungsart', :with => 'Zum schönen Wohnen'
          fill_in 'Bezugstermin', :with => 'ca. Herbst 2010 für Mieter'
          fill_in 'Ausrichtung Nordpfeil', :with => '45'
        end
      end

      it 'saves a new Description' do
        click_on 'Beschreibungen erstellen'
        @real_estate.reload
        @real_estate.descriptions.should be_a(Description)
      end

      context '#create' do
        before :each do
          click_on 'Beschreibungen erstellen'
          @real_estate.reload
          @description = @real_estate.descriptions
        end

        it 'has saved the provided attributes' do
          @description.generic.should == 'Modernes Wohnen in schöner Landschaft'
          @description.location.should == 'In laufweite zum Flughafen'
          @description.interior.should == 'Top moderne Küche'
          @description.offer.should == 'Schöne Aussicht'
          @description.infrastructure.should == 'An bester Einkaufslage'
          @description.usage.should == 'Zum schönen Wohnen'
          @description.reference_date.should == 'ca. Herbst 2010 für Mieter'
          @description.orientation_degrees.should == 45
        end
      end
    end
  end
end
