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
      current_path.should == new_cms_real_estate_additional_description_path(@real_estate)
    end

    context 'a valid Description' do
      before :each do
        within(".new_additional_description") do
          fill_in 'Standort', :with => 'In laufweite zum Flughafen'
          fill_in 'Ausbaustandard', :with => 'Top moderne Küche'
          fill_in 'Angebot', :with => 'Schöne Aussicht'
          fill_in 'Infrastruktur', :with => 'An bester Einkaufslage'
          fill_in 'Ausrichtung Nordpfeil', :with => '45'
        end
      end

      it 'saves a new Description' do
        click_on 'Beschreibungen erstellen'
        @real_estate.reload
        @real_estate.additional_description.should be_a(AdditionalDescription)
      end

      context '#create' do
        before :each do
          click_on 'Beschreibungen erstellen'
          @real_estate.reload
          @additional_description = @real_estate.additional_description
        end

        it 'has saved the provided attributes' do
          @additional_description.location.should == 'In laufweite zum Flughafen'
          @additional_description.interior.should == 'Top moderne Küche'
          @additional_description.offer.should == 'Schöne Aussicht'
          @additional_description.infrastructure.should == 'An bester Einkaufslage'
          @additional_description.orientation_degrees.should == 45
        end
      end
    end
  encoding

  describe '#show' do
    let :real_estate_with_desc do
      Fabricate :real_estate, :category => Fabricate(:category), :additional_description => Fabricate.build(:additional_description)
    end

    let :real_estate_without_desc do
      Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'shows the additional description within the cms' do
      visit cms_real_estate_additional_description_path real_estate_with_desc
      [:location, :interior, :offer, :infrastructure].each do |attr|
        page.should have_content real_estate_with_desc.additional_description.send(attr)
      end
    end

    it 'shows a message if no description exist' do
      visit cms_real_estate_additional_description_path real_estate_without_desc
      page.should have_content "Für diese Immobilie wurden keine Beschreibungen hinterlegt."
    end

  end

end
