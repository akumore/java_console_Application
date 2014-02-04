# encoding: utf-8

require 'spec_helper'

describe "Cms Information" do
  login_cms_user

  describe '#new' do

    before :each do
      @template_information = Fabricate.build(:information,
                                                :has_outlook => true,
                                                :has_fireplace => true,
                                                :has_elevator => true,
                                                :has_isdn => true,
                                                :is_wheelchair_accessible => true,
                                                :is_child_friendly => true,
                                                :has_balcony => true,
                                                :has_garden_seating => true,
                                                :has_raised_ground_floor => true,
                                                :is_new_building => true,
                                                :is_old_building => true,
                                                :has_swimming_pool => true,
                                                :is_minergie_style => true,
                                                :is_minergie_certified => true,
                                                :maximal_floor_loading => 10,
                                                :freight_elevator_carrying_capacity => 20,
                                                :has_ramp => true,
                                                :has_lifting_platform => true,
                                                :has_railway_terminal => true,
                                                :number_of_restrooms => 10,
                                                :has_water_supply => true,
                                                :has_sewage_supply => true,
                                                :is_developed => true,
                                                :is_under_building_laws => true,
                                                :has_cable_tv => true,
                                                :additional_information => 'Zusätzliche Angaben zum Ausbau',
                                                :floors => 3,
                                                :renovated_on => 1997,
                                                :built_on => 1956,
                                                :ceiling_height => '2.6'
                                              )
    end

    context 'real estate with living utilization' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :category => Fabricate(:category),
          :utilization => Utilization::LIVING
        )
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'creates a new information object' do

        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information
        fill_in 'Anzahl Geschosse', :with => @template_information.floors
        fill_in 'Renovationsjahr', :with => @template_information.renovated_on
        fill_in 'Baujahr', :with => @template_information.built_on
        
        fill_in 'Öffentlicher Verkehr', :with => '200'
        fill_in 'Einkaufen', :with => '100'

        [ 'Aussicht', 
          'Cheminée', 
          'Lift', 
          'ISDN-Anschluss', 
          'Rollstuhltauglich', 
          'Kinderfreundlich', 
          'Balkon', 
          'Gartensitzplatz',
          'Hochparterre', 
          'Neubau', 
          'Altbau', 
          'Swimmingpool', 
          'Minergie Bauweise', 
          'Minergie zertifiziert',
          'Kabelfernsehen'
        ].each do |checkbox|
          check checkbox
        end

        click_on 'Immobilieninfos erstellen'

        @real_estate.reload
        information = @real_estate.information

        expect(information.has_outlook).to eq @template_information.has_outlook
        expect(information.has_fireplace).to eq @template_information.has_fireplace
        expect(information.has_elevator).to eq @template_information.has_elevator
        expect(information.has_isdn).to eq @template_information.has_isdn
        expect(information.is_wheelchair_accessible).to eq @template_information.is_wheelchair_accessible
        expect(information.is_child_friendly).to eq @template_information.is_child_friendly
        expect(information.has_balcony).to eq @template_information.has_balcony
        expect(information.has_garden_seating).to eq @template_information.has_garden_seating
        expect(information.has_raised_ground_floor).to eq @template_information.has_raised_ground_floor
        expect(information.has_swimming_pool).to eq @template_information.has_swimming_pool
        expect(information.has_isdn).to eq @template_information.has_isdn
        expect(information.is_new_building).to eq @template_information.is_new_building
        expect(information.is_old_building).to eq @template_information.is_old_building
        expect(information.is_minergie_style).to eq @template_information.is_minergie_style
        expect(information.is_minergie_certified).to eq @template_information.is_minergie_certified
        expect(information.has_cable_tv).to eq @template_information.has_cable_tv
        expect(information.floors).to eq @template_information.floors
        expect(information.renovated_on).to eq @template_information.renovated_on
        expect(information.built_on).to eq @template_information.built_on
        expect(information.points_of_interest.length).to eq 6
        expect(information.location_html).to eq 'In laufweite zum Flughafen'

        updated_additional_infos = [
          "<ul>",
          "\t<li>Minergie Bauweise</li>",
          "\t<li>Minergie zertifiziert</li>",
          "\t<li>Kabelfernsehen</li>",
          "\t<li>Ausblick</li>",
          "\t<li>Cheminée</li>",
          "\t<li>Liftzugang</li>",
          "\t<li>ISDN Anschluss</li>",
          "\t<li>rollstuhltauglich</li>",
          "\t<li>kinderfreundlich</li>",
          "\t<li>Balkon</li>",
          "\t<li>Gartensitzplatz</li>",
          "\t<li>Schwimmbecken</li>",
          "</ul>",
          "Zusätzliche Angaben zum Ausbau"]
        information.additional_information.should == updated_additional_infos.join("\r\n")

        within('.alert') do
          page.should have_content('Ergänzende Informationen wurden automatisch ergänzt. Bitte überprüfen Sie den Inhalt')
        end

        find_field('Ergänzende Informationen').value.should eq updated_additional_infos.join("\n")

        click_on 'Immobilieninfos speichern'
        current_path.should == cms_real_estate_media_assets_path(@real_estate)
      end

      it 'doesnt render the is_developed checkbox' do
        expect(page).to_not have_css('#information_is_developed')
      end

      it 'doesnt render the is_under_building_laws_checkbox' do
        expect(page).to_not have_css('#information_is_under_building_laws')
      end

      it 'doesnt render the has_lifting_platform checkbox' do
        expect(page).to_not have_css('#information_has_lifting_platform')
      end

      it 'doesnt render the has_ramp checkbox' do
        expect(page).to_not have_css('#information_has_ramp')
      end

      it 'doesnt render the maximal_floor_loading input field' do
        expect(page).to_not have_css('#information_maximal_floor_loading')
      end

      it 'doesnt render the has_sewage_supply checkbox' do
        expect(page).to_not have_css('#information_has_sewage_supply')
      end

      it 'doesnt render the has_water_supply checkbox' do
        expect(page).to_not have_css('#information_has_water_supply')
      end

      it 'doesnt render the number_of_restrooms input field' do
        expect(page).to_not have_css('#information_number_of_restrooms')
      end

      it 'doesnt render the ceiling_height input field' do
        expect(page).to_not have_css('#information_ceiling_height')
      end
    end

    context 'real estate with working utilization' do
      before :each do
        @real_estate = Fabricate(:real_estate,
                                 :category => Fabricate(:category),
                                 :utilization => Utilization::WORKING
                                )
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'creates a new information object' do

        fill_in "Anzahl WC's", :with => @template_information.number_of_restrooms
        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information
        fill_in 'Anzahl Geschosse', :with => @template_information.floors
        fill_in 'Renovationsjahr', :with => @template_information.renovated_on
        fill_in 'Baujahr', :with => @template_information.built_on
        fill_in 'Raumhöhe in Meter', :with => @template_information.ceiling_height

        [
         'Aussicht',
         'Neubau',
         'Minergie Bauweise',
         'Minergie zertifiziert',
         'Anfahrrampe',
         'Hebebühne',
         'Bahnanschluss',
         'Kabelfernsehen'
        ].each do |checkbox|
          check checkbox
        end

        click_on 'Immobilieninfos erstellen'

        @real_estate.reload
        information = @real_estate.information

        expect(information.has_outlook).to eq @template_information.has_outlook
        expect(information.is_new_building).to eq @template_information.is_new_building
        expect(information.is_minergie_style).to eq @template_information.is_minergie_style
        expect(information.is_minergie_certified).to eq @template_information.is_minergie_certified
        expect(information.has_ramp).to eq @template_information.has_ramp
        expect(information.has_lifting_platform).to eq @template_information.has_lifting_platform
        expect(information.has_railway_terminal).to eq @template_information.has_railway_terminal
        expect(information.number_of_restrooms).to eq @template_information.number_of_restrooms
        expect(information.has_cable_tv).to eq @template_information.has_cable_tv
        expect(information.floors).to eq @template_information.floors
        expect(information.renovated_on).to eq @template_information.renovated_on
        expect(information.built_on).to eq @template_information.built_on
        expect(information.ceiling_height).to eq @template_information.ceiling_height
      end

      it 'doesnt render the has_swimming_pool checkbox' do
        expect(page).to_not have_css('#information_has_swimming_pool')
      end

      it 'doesnt render the is_child_friendly checkbox' do
        expect(page).to_not have_css('#information_is_child_friendly')
      end

      it 'doesnt render the has_fireplace checkbox' do
        expect(page).to_not have_css('#information_has_fireplace')
      end

      it 'doesnt render the is_old_building checkbox' do
        expect(page).to_not have_css('#information_is_old_building')
      end

      it 'doesnt render the is_under_building_laws checkbox' do
        expect(page).to_not have_css('#information_is_under_building_laws')
      end

      it 'doesnt render the has_sewage_supply checkbox' do
        expect(page).to_not have_css('#information_has_sewage_supply')
      end

      it 'doesnt render the has_water_supply checkbox' do
        expect(page).to_not have_css('#information_has_water_supply')
      end

      ["Anzahl WC's", "Max Gewicht Warenlift", "Max Bodenbelastung"].each do |target_field|

        it "fails to create because of invalid '#{target_field}' entered" do
          fill_in target_field, :with => -9
          lambda {
            click_on 'Immobilieninfos erstellen'
            @real_estate.reload
          }.should_not change(@real_estate, :information)
        end

        it "doesn't fail to create on empty numerical field '#{target_field}'" do
          fill_in target_field, :with => ''
          lambda {
            click_on 'Immobilieninfos erstellen'
            @real_estate.reload
          }.should change(@real_estate, :information)
        end
      end
    end

    context 'real estate with storing utilization' do
      before :each do
        @real_estate = Fabricate(:real_estate,
                                 :category => Fabricate(:category),
                                 :utilization => Utilization::STORING
                                )
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'creates a new information object' do

        fill_in "Anzahl WC's", :with => @template_information.number_of_restrooms
        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information
        fill_in 'Anzahl Geschosse', :with => @template_information.floors
        fill_in 'Renovationsjahr', :with => @template_information.renovated_on
        fill_in 'Baujahr', :with => @template_information.built_on
        fill_in 'Raumhöhe in Meter', :with => @template_information.ceiling_height

        [
          'Aussicht',
          'Neubau',
          'Minergie Bauweise',
          'Minergie zertifiziert',
          'Anfahrrampe',
          'Hebebühne',
          'Bahnanschluss',
          'Wasseranschluss',
          'Abwasseranschluss',
          'Kabelfernsehen'
        ].each do |checkbox|
          check checkbox
        end

        click_on 'Immobilieninfos erstellen'

        @real_estate.reload
        information = @real_estate.information

        expect(information.has_outlook).to eq @template_information.has_outlook
        expect(information.is_new_building).to eq @template_information.is_new_building
        expect(information.is_minergie_style).to eq @template_information.is_minergie_style
        expect(information.is_minergie_certified).to eq @template_information.is_minergie_certified
        expect(information.has_ramp).to eq @template_information.has_ramp
        expect(information.has_lifting_platform).to eq @template_information.has_lifting_platform
        expect(information.has_railway_terminal).to eq @template_information.has_railway_terminal
        expect(information.has_water_supply).to eq @template_information.has_water_supply
        expect(information.has_sewage_supply).to eq @template_information.has_sewage_supply
        expect(information.number_of_restrooms).to eq @template_information.number_of_restrooms
        expect(information.has_cable_tv).to eq @template_information.has_cable_tv
        expect(information.floors).to eq @template_information.floors
        expect(information.renovated_on).to eq @template_information.renovated_on
        expect(information.built_on).to eq @template_information.built_on
        expect(information.ceiling_height).to eq @template_information.ceiling_height
      end
    end

    context "a real estate with 'properties' category" do
      before :each do
        @real_estate = Fabricate(:real_estate, :category => Fabricate(:properties_category))
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'renders the is_developed checkbox' do
        @real_estate.property?.should be_true
        page.should have_css('#information_is_developed')
      end
    end

    context "when for sale" do
      %w(house apartment).each do |category_name|
        context "a real estate with a '#{category_name}' category" do
          before :each do
            @real_estate = Fabricate(:real_estate, :category => Fabricate("#{category_name}_category".to_sym))
            @real_estate.update_attribute(:offer, Offer::SALE)
            visit new_cms_real_estate_information_path(@real_estate)
          end

          it 'renders the is_under_building_laws checkbox' do
            page.should have_css('#information_is_under_building_laws')
          end
        end
      end
    end

    context "when for rent" do
      %w(house apartment).each do |category_name|
        context "a real estate with a '#{category_name}' category" do
          before :each do
            @real_estate = Fabricate(:real_estate, :category => Fabricate("#{category_name}_category".to_sym))
            @real_estate.update_attribute(:offer, Offer::RENT)
            visit new_cms_real_estate_information_path(@real_estate)
          end

          it 'renders the is_under_building_laws checkbox' do
            page.should_not have_css('#information_is_under_building_laws')
          end
        end
      end
    end
  end

  describe '#edit' do
    before do
      @real_estate = Fabricate(:real_estate,
                                     :information => Fabricate.build(:information,
                                                                     :number_of_restrooms => 0),
                                     :category => Fabricate(:category),
                                     :utilization => Utilization::WORKING
                              )
      @information = @real_estate.information
    end

    it "doesn't update invalid objects" do
      visit edit_cms_real_estate_information_path(@real_estate)
      fill_in "Anzahl WC's", :with=>-9

      lambda {
        click_on 'Immobilieninfos speichern'
        @information.reload
      }.should_not change(@information, :number_of_restrooms)
    end

    it 'updates the additional information field' do
      visit edit_cms_real_estate_information_path(@real_estate)

      check 'Kabelfernsehen'
      click_on 'Immobilieninfos speichern'

      within('.alert') do
        page.should have_content('Ergänzende Informationen wurden automatisch ergänzt. Bitte überprüfen Sie den Inhalt')
      end

      click_on 'Immobilieninfos speichern'
      current_path.should == cms_real_estate_media_assets_path(@real_estate)
    end
  end


  describe '#show' do
    let :real_estate do
      Fabricate :real_estate, :category => Fabricate(:category), :information => Fabricate.build(:information)
    end

    let :real_estate_without_information do
      Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'shows the additional information text' do
      visit cms_real_estate_information_path real_estate
      page.should have_content real_estate.information.additional_information
      page.should have_content real_estate.information.location_html
    end

    it 'shows a message if no information exist' do
      visit cms_real_estate_information_path real_estate_without_information
      page.should have_content "Für diese Immobilie wurden keine weiteren Informationen hinterlegt."
    end
  end
end
