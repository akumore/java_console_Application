# encoding: utf-8

require 'spec_helper'

describe "Cms Information" do
  login_cms_user

  describe '#new' do

    before :each do
      @template_information = Fabricate.build(:information,
                                                :available_from => Date.parse('2012-04-24'),
                                                :display_estimated_available_from => 'Ab Ende April',
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
                                                :additional_information => 'Zusätzliche Angaben zum Ausbau'
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

        select '24', :from => 'information_available_from_3i'
        select 'April', :from => 'information_available_from_2i'
        select '2012', :from => 'information_available_from_1i'

        fill_in 'Etwa verfügbar ab', :with => @template_information.display_estimated_available_from
        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information

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

        information.has_outlook.should == @template_information.has_outlook
        information.has_fireplace.should == @template_information.has_fireplace
        information.has_elevator.should == @template_information.has_elevator
        information.has_isdn.should == @template_information.has_isdn
        information.is_wheelchair_accessible.should == @template_information.is_wheelchair_accessible
        information.is_child_friendly.should == @template_information.is_child_friendly
        information.has_balcony.should == @template_information.has_balcony
        information.has_garden_seating.should == @template_information.has_garden_seating
        information.has_raised_ground_floor.should == @template_information.has_raised_ground_floor
        information.has_swimming_pool.should == @template_information.has_swimming_pool
        information.has_isdn.should == @template_information.has_isdn
        information.is_new_building.should == @template_information.is_new_building
        information.is_old_building.should == @template_information.is_old_building
        information.is_minergie_style.should == @template_information.is_minergie_style
        information.is_minergie_certified.should == @template_information.is_minergie_certified
        information.available_from.should == @template_information.available_from
        information.display_estimated_available_from.should == @template_information.display_estimated_available_from
        information.has_cable_tv.should == @template_information.has_cable_tv

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
          page.should have_content('Ergänzende informationen wurde automatisch ergänzt. Bitte überprüfen sie den Inhalt')
        end

        find_field('Ergänzende Informationen').value.should eq updated_additional_infos.join("\n")

        click_on 'Immobilieninfos speichern'
        current_path.should == new_cms_real_estate_pricing_path(@real_estate)
      end

      it 'doesnt render the is_developed checkbox' do
        page.should_not have_css('#is_developed')
      end

      it 'doesnt render the is_under_building_laws_checkbox' do
        page.should_not have_css('#is_under_building_laws')
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

        select '24', :from => 'information_available_from_3i'
        select 'April', :from => 'information_available_from_2i'
        select '2012', :from => 'information_available_from_1i'

        fill_in 'Etwa verfügbar ab', :with => @template_information.display_estimated_available_from
        fill_in "Anzahl WC's", :with => @template_information.number_of_restrooms
        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information

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

        information.has_outlook.should == @template_information.has_outlook
        information.is_new_building.should == @template_information.is_new_building
        information.is_minergie_style.should == @template_information.is_minergie_style
        information.is_minergie_certified.should == @template_information.is_minergie_certified
        information.has_ramp.should == @template_information.has_ramp
        information.has_lifting_platform.should == @template_information.has_lifting_platform
        information.has_railway_terminal.should == @template_information.has_railway_terminal
        information.has_water_supply.should == @template_information.has_water_supply
        information.has_sewage_supply.should == @template_information.has_sewage_supply
        information.available_from.should == @template_information.available_from
        information.display_estimated_available_from.should == @template_information.display_estimated_available_from
        information.number_of_restrooms.should == @template_information.number_of_restrooms
        information.has_cable_tv.should == @template_information.has_cable_tv
      end

      ["Anzahl WC's", "Max Gewicht Warenlift", "Maximale Bodenbelastung"].each do |target_field|

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

        select '24', :from => 'information_available_from_3i'
        select 'April', :from => 'information_available_from_2i'
        select '2012', :from => 'information_available_from_1i'

        fill_in 'Etwa verfügbar ab', :with => @template_information.display_estimated_available_from
        fill_in "Anzahl WC's", :with => @template_information.number_of_restrooms
        fill_in 'Ergänzende Informationen', :with => @template_information.additional_information

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

        information.has_outlook.should == @template_information.has_outlook
        information.is_new_building.should == @template_information.is_new_building
        information.is_minergie_style.should == @template_information.is_minergie_style
        information.is_minergie_certified.should == @template_information.is_minergie_certified
        information.has_ramp.should == @template_information.has_ramp
        information.has_lifting_platform.should == @template_information.has_lifting_platform
        information.has_railway_terminal.should == @template_information.has_railway_terminal
        information.has_water_supply.should == @template_information.has_water_supply
        information.has_sewage_supply.should == @template_information.has_sewage_supply
        information.available_from.should == @template_information.available_from
        information.display_estimated_available_from.should == @template_information.display_estimated_available_from
        information.number_of_restrooms.should == @template_information.number_of_restrooms
        information.has_cable_tv.should == @template_information.has_cable_tv
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
                                                               :available_from => Date.parse('2012-04-26'),
                                                               :number_of_restrooms => 0
                                                              ),
                                                              :category => Fabricate(:category),
                                                              :utilization => Utilization::WORKING
                              )
      @information = @real_estate.information
    end

    it "updates the information object" do
      visit edit_cms_real_estate_information_path(@real_estate)
      fill_in 'Etwa verfügbar ab', :with=>'Ebenfalls ab Ende April verfügbar'

      lambda {
        click_on 'Immobilieninfos speichern'
        @information.reload
      }.should change(@information, :display_estimated_available_from)
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
        page.should have_content('Ergänzende informationen wurde automatisch ergänzt. Bitte überprüfen sie den Inhalt')
      end

      click_on 'Immobilieninfos speichern'
      current_path.should == new_cms_real_estate_pricing_path(@real_estate)
    end
  end


  describe '#show' do
    let :real_estate do
      Fabricate :real_estate, :category => Fabricate(:category), :information => Fabricate.build(:information)
    end

    let :real_estate_without_information do
      Fabricate :real_estate, :category => Fabricate(:category)
    end

    it 'shows the information within the cms' do
      visit cms_real_estate_information_path real_estate
      [:available_from, :display_estimated_available_from].each do |attr|
        page.should have_content real_estate.information.send(attr)
      end
    end

    it 'shows the additional information text' do
      visit cms_real_estate_information_path real_estate
      page.should have_content real_estate.information.additional_information
    end

    it 'shows a message if no information exist' do
      visit cms_real_estate_information_path real_estate_without_information
      page.should have_content "Für diese Immobilie wurden keine Infos hinterlegt."
    end
  end
end
