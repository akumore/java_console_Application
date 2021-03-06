# encoding: utf-8
require 'spec_helper'

describe "Cms::Figures" do
  login_cms_user
  create_category_tree

  context 'in a real estate with private utilization' do
    describe '#new' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :utilization => Utilization::LIVING,
          :category => Category.last,
          :reference => Fabricate.build(:reference)
        )
        visit edit_cms_real_estate_path(@real_estate)
        click_on 'Objektübersicht'
      end

      it 'opens the create form' do
        current_path.should == new_cms_real_estate_figure_path(@real_estate)
      end

      it 'does show the storage surface input' do
        page.should have_css('#figure_storage_surface')
      end

      it 'does not show the usage surface input' do
        page.should_not have_css('#figure_usage_surface')
      end

      it 'does not show the usage surface estimate input' do
        page.should_not have_css('#figure_usage_surface_estimate')
      end

      it 'does show the offer html' do
        page.should have_css('#figure_offer_html')
      end

      it 'replaces old lis' do
        fill_in 'figure_rooms', :with => '3.5'
        fill_in 'figure_floor', :with => '-1'
        fill_in 'figure_covered_slot', :with => '1'
        click_on 'Objektübersicht erstellen'

        @real_estate.reload
        expect(@real_estate.figure.offer_html).to eq "<ul>\r\n\t<li>1. Untergeschoss</li>\r\n\t<li>3.5 Zimmer</li>\r\n\t<li>1 Parkplatz im Freien überdacht</li>\r\n</ul>"

        fill_in 'figure_covered_slot', :with => '66'
        click_on 'Objektübersicht speichern'

        @real_estate.reload
        expect(@real_estate.figure.offer_html).to eq "<ul>\r\n\t<li>1. Untergeschoss</li>\r\n\t<li>3.5 Zimmer</li>\r\n\t<li>66 Parkplätze im Freien überdacht</li>\r\n</ul>"

        fill_in 'figure_covered_slot', :with => ''
        click_on 'Objektübersicht speichern'

        @real_estate.reload
        expect(@real_estate.figure.offer_html).to eq "<ul>\r\n\t<li>1. Untergeschoss</li>\r\n\t<li>3.5 Zimmer</li>\r\n</ul>"
      end

      context 'a valid Figure' do
        before :each do
          within(".new_figure") do
            fill_in 'figure_floor', :with => '-1'
            fill_in 'figure_floor_estimate', :with => 'UG. - 2.OG'
            fill_in 'figure_rooms', :with => '3.5'
            fill_in 'figure_rooms_estimate', :with => '3 - 3.5 Zimmer'
            fill_in 'figure_living_surface', :with => '124.6'
            fill_in 'figure_living_surface_estimate', :with => '124.6 - 130.4m2'
            fill_in 'figure_property_surface', :with => '400.5'
            fill_in 'figure_property_surface_estimate', :with => '124.5 - 123m2'
            fill_in 'figure_inside_parking_spots', :with => '1'
            fill_in 'figure_outside_parking_spots', :with => '2'
            fill_in 'figure_covered_slot', :with => '3'
            fill_in 'figure_covered_bike', :with => '4'
            fill_in 'figure_outdoor_bike', :with => '5'
            fill_in 'figure_single_garage', :with => '6'
            fill_in 'figure_double_garage', :with => '7'
          end
        end

        it 'saves a new Figure' do
          click_on 'Objektübersicht erstellen'
          @real_estate.reload
          @real_estate.figure.should be_a(Figure)
        end

        context '#create' do
          before :each do
            click_on 'Objektübersicht erstellen'
            @real_estate.reload
            @figure = @real_estate.figure
          end

          it 'has saved the provided attributes' do
            @figure.floor.should == -1
            @figure.floor_estimate.should == 'UG. - 2.OG'
            @figure.rooms.should ==  '3.5'
            @figure.rooms_estimate.should == '3 - 3.5 Zimmer'
            @figure.living_surface.should == 124.6
            @figure.living_surface_estimate.should == '124.6 - 130.4m2'
            @figure.property_surface.should == '400.5'
            @figure.property_surface_estimate.should == '124.5 - 123m2'
            @figure.inside_parking_spots.should == 1
            @figure.outside_parking_spots.should == 2
            @figure.covered_slot.should == 3
            @figure.covered_bike.should == 4
            @figure.outdoor_bike.should == 5
            @figure.single_garage.should == 6
            @figure.double_garage.should == 7
            @figure.offer_html.to_s.should == "<ul>\r\n\t<li>UG. - 2.OG</li>\r\n\t<li>3 - 3.5 Zimmer</li>\r\n\t<li>Wohnfläche 124.6 - 130.4m2</li>\r\n\t<li>Grundstückfläche 124.5 - 123m2</li>\r\n\t<li>1 Parkplatz in Autoeinstellhalle</li>\r\n\t<li>2 Parkplätze im Freien</li>\r\n\t<li>3 Parkplätze im Freien überdacht</li>\r\n\t<li>4 Motorrad-Parkplätze in Autoeinstellhalle</li>\r\n\t<li>5 Motorrad-Parkplätze im Freien überdacht</li>\r\n\t<li>6 Einzelgaragen</li>\r\n\t<li>7 Doppelgaragen</li>\r\n</ul>"

            expect(page).to have_content('Angebot Beschreibung wurde automatisch ergänzt. Bitte überprüfen Sie den Inhalt')
          end

        end
      end
    end
  end

  context 'in a real estate with commercial utilization' do
    describe '#new' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :utilization => Utilization::WORKING,
          :category => Category.last,
          :reference => Fabricate.build(:reference)
        )
        visit edit_cms_real_estate_path(@real_estate)
        click_on 'Objektübersicht'
      end

      it 'opens the create form' do
        current_path.should == new_cms_real_estate_figure_path(@real_estate)
      end

      it 'does not show the number of rooms input' do
        page.should_not have_css('#figure_rooms')
      end

      it 'does not show the number of room estimated input' do
        page.should_not have_css('#figure_rooms_estimate')
      end

      it 'does not show the living surface input' do
        page.should_not have_css('#figure_living_surface')
      end

      it 'does not show the living surface estimate input' do
        page.should_not have_css('#figure_living_surface_estimate')
      end

      context 'a valid Figure' do
        before :each do
          within(".new_figure") do
            fill_in 'figure_floor', :with => '-1'
            fill_in 'figure_floor_estimate', :with => 'UG. - 2.OG'
            fill_in 'figure_property_surface', :with => '400.5'
            fill_in 'figure_property_surface_estimate', :with => '40.3 - 120 m2'
            fill_in 'figure_usable_surface', :with => '200.6'
            fill_in 'figure_usable_surface_estimate', :with => '200.6 - 200.7 m2'
            fill_in 'figure_storage_surface', :with => '150'
            fill_in 'figure_inside_parking_spots', :with => '1'
            fill_in 'figure_outside_parking_spots', :with => '2'
            fill_in 'figure_covered_slot', :with => '3'
            fill_in 'figure_covered_bike', :with => '4'
            fill_in 'figure_outdoor_bike', :with => '5'
            fill_in 'figure_single_garage', :with => '6'
            fill_in 'figure_double_garage', :with => '7'
          end
        end

        it 'saves a new Figure' do
          click_on 'Objektübersicht erstellen'
          @real_estate.reload
          @real_estate.figure.should be_a(Figure)
        end

        context '#create' do
          before :each do
            click_on 'Objektübersicht erstellen'
            @real_estate.reload
            @figure = @real_estate.figure
          end

          it 'has saved the provided attributes' do
            @figure.floor.should == -1
            @figure.floor_estimate.should == 'UG. - 2.OG'
            @figure.property_surface.should == '400.5'
            @figure.property_surface_estimate.should == '40.3 - 120 m2'
            @figure.usable_surface.should == 200.6
            @figure.usable_surface_estimate.should == '200.6 - 200.7 m2'
            @figure.storage_surface.should == '150'
            @figure.inside_parking_spots.should == 1
            @figure.outside_parking_spots.should == 2
            @figure.covered_slot.should == 3
            @figure.covered_bike.should == 4
            @figure.outdoor_bike.should == 5
            @figure.single_garage.should == 6
            @figure.double_garage.should == 7
          end
        end
      end
    end
  end

  describe '#show' do
     let :real_estate do
       Fabricate :real_estate, :category => Fabricate(:category), :figure => Fabricate.build(:figure)
     end

     it 'shows the figure within the cms' do
       visit cms_real_estate_figure_path real_estate
       [:floor,:rooms,:living_surface,].each do |attr|
         page.should have_content real_estate.figure.send(attr)
       end

      [:has_parking_spot,:has_garage].each do |attr|
        page.should have_content I18n.t("#{real_estate.figure.send(attr)}")
      end
    end
  end

end
