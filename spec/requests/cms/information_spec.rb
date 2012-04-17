# encoding: utf-8

require 'spec_helper'

describe "Cms Information" do
  login_cms_user

  describe '#new' do

    before :each do
      @template_information = Fabricate.build(:information,
                                                :available_from=>Date.parse('2012-04-24'),
                                                :display_estimated_available_from=>'Ab Ende April',
                                                :has_outlook=>true,
                                                :has_fireplace=>true,
                                                :has_elevator=>true,
                                                :has_isdn=>true,
                                                :is_wheelchair_accessible=>true,
                                                :is_child_friendly=>true,
                                                :has_balcony=>true,
                                                :has_raised_ground_floor=>true,
                                                :is_new_building=>true,
                                                :is_old_building=>true,
                                                :has_swimming_pool=>true,
                                                :is_minergie_style=>true,
                                                :is_minergie_certified=>true,
                                                :maximal_floor_loading=>10,
                                                :freight_elevator_carrying_capacity=>20,
                                                :has_ramp=>true,
                                                :has_lifting_platform=>true,
                                                :has_railway_terminal=>true,
                                                :number_of_restrooms=>10,
                                                :has_water_supply=>true,
                                                :has_sewage_supply=>true,
                                                :is_developed=>true,
                                                :is_under_building_laws=>true,
                                                :minimum_rental_period => '1 Jahr',
                                                :notice_dates => 'März, Juni, Oktober',
                                                :notice_period => '3 Monate'
                                              )
    end

    context 'real estate with private utilization' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :category => Fabricate(:category),
          :utilization => RealEstate::UTILIZATION_PRIVATE
        )
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'creates a new information object' do

        select '24', :from => 'information_available_from_3i'
        select 'April', :from => 'information_available_from_2i'
        select '2012', :from => 'information_available_from_1i'

        fill_in 'Etwa verfügbar ab', :with => @template_information.display_estimated_available_from
        fill_in 'Mindestmietdauer', :with => @template_information.minimum_rental_period
        fill_in 'Kündigungstermine', :with => @template_information.notice_dates
        fill_in 'Kündigungsfrist', :with => @template_information.notice_period

        ['Aussicht', 'Cheminée', 'Lift', 'ISDN-Anschluss', 'Rollstuhltauglich', 'Kinderfreundlich', 'Balkon',
         'Hochparterre', 'Neubau', 'Altbau', 'Swimmingpool', 'Minergie Bauweise', 'Minergie zertifiziert'].each do |checkbox|
          check checkbox
        end

        click_on 'Immobilieninfos erstellen'

        @real_estate.reload
        information = @real_estate.information

        information.minimum_rental_period == @template_information.minimum_rental_period
        information.notice_dates == @template_information.notice_dates
        information.notice_period == @template_information.notice_period
        information.has_outlook.should == @template_information.has_outlook
        information.has_fireplace.should == @template_information.has_fireplace
        information.has_elevator.should == @template_information.has_elevator
        information.has_isdn.should == @template_information.has_isdn
        information.is_wheelchair_accessible.should == @template_information.is_wheelchair_accessible
        information.is_child_friendly.should == @template_information.is_child_friendly
        information.has_balcony.should == @template_information.has_balcony
        information.has_raised_ground_floor.should == @template_information.has_raised_ground_floor
        information.has_swimming_pool.should == @template_information.has_swimming_pool
        information.has_isdn.should == @template_information.has_isdn
        information.is_new_building.should == @template_information.is_new_building
        information.is_old_building.should == @template_information.is_old_building
        information.is_minergie_style.should == @template_information.is_minergie_style
        information.is_minergie_certified.should == @template_information.is_minergie_certified
        information.available_from.should == @template_information.available_from
        information.display_estimated_available_from.should == @template_information.display_estimated_available_from
      end

      it 'doesnt render the is_developed checkbox' do
        page.should_not have_css('#is_developed')
      end

      it 'doesnt render the is_under_building_laws_checkbox' do
        page.should_not have_css('#is_under_building_laws')
      end
    end

    context 'real estate with commercial utilization' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :category => Fabricate(:category),
          :utilization => RealEstate::UTILIZATION_COMMERICAL
          )
        visit new_cms_real_estate_information_path(@real_estate)
      end

      it 'creates a new information object' do

        select '24', :from => 'information_available_from_3i'
        select 'April', :from => 'information_available_from_2i'
        select '2012', :from => 'information_available_from_1i'

        fill_in 'Etwa verfügbar ab', :with => @template_information.display_estimated_available_from
        fill_in "Anzahl WC's", :with => @template_information.number_of_restrooms
        fill_in 'Mindestmietdauer', :with => @template_information.minimum_rental_period
        fill_in 'Kündigungstermine', :with => @template_information.notice_dates
        fill_in 'Kündigungsfrist', :with => @template_information.notice_period

        ['Neubau', 'Altbau', 'Minergie Bauweise', 'Minergie zertifiziert', 'Anfahrrampe',
         'Hebebühne', 'Bahnanschluss', 'Wasseranschluss', 'Abwasseranschluss'].each do |checkbox|
          check checkbox
        end

        click_on 'Immobilieninfos erstellen'

        @real_estate.reload
        information = @real_estate.information

        information.minimum_rental_period == @template_information.minimum_rental_period
        information.notice_dates == @template_information.notice_dates
        information.notice_period == @template_information.notice_period
        information.is_new_building.should == @template_information.is_new_building
        information.is_old_building.should == @template_information.is_old_building
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

    %w(house apartment).each do |category_name|
      context "a real estate with a '#{category_name}' category" do
        before :each do
          @real_estate = Fabricate(:real_estate, :category => Fabricate("#{category_name}_category".to_sym))
          visit new_cms_real_estate_information_path(@real_estate)
        end

        it 'renders the is_under_building_laws checkbox' do
          page.should have_css('#information_is_under_building_laws')
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
                                     :utilization => RealEstate::UTILIZATION_COMMERICAL
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

     it 'shows a message if no information exist' do
       visit cms_real_estate_information_path real_estate_without_information
       page.should have_content "Für diese Immobilie wurden keine Infos hinterlegt."
     end

  end

end
