# encoding: utf-8
require 'spec_helper'

describe "Cms::Figures" do
  login_cms_user
  create_category_tree

  context 'in a real estate with private utilization' do
    describe '#new' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :utilization => RealEstate::UTILIZATION_PRIVATE,
          :category => Category.last, 
          :reference => Fabricate.build(:reference)
        )
        visit edit_cms_real_estate_path(@real_estate)
        click_on 'Zahlen und Fakten'
      end

      it 'opens the create form' do
        current_path.should == new_cms_real_estate_figure_path(@real_estate)
      end

      it 'does not show the storage surface input' do
        page.should_not have_css('textarea[name=storage_surface]')
      end

      context 'a valid Figure' do
        before :each do
          within(".new_figure") do
            fill_in 'Stockwerk', :with => '-1'
            fill_in 'Stockwerk ungefähr', :with => 'UG. - 2.OG'
            fill_in 'Anzahl Zimmer', :with => '3.5'
            fill_in 'Anzahl Zimmer ungefähr', :with => '3 - 3.5 Zimmer'
            fill_in 'Wohnfläche', :with => '124.6'
            fill_in 'Wohnfläche ungefähr', :with => '124.6 - 130.4m2'
            fill_in 'Grundstückfläche', :with => '400.5'
            fill_in 'Nutzfläche', :with => '200.6'
            fill_in 'Raumhöhe', :with => '2.6'
            fill_in 'Anzahl Stockwerke', :with => 3
            fill_in 'Renovationsjahr', :with => 1997
            fill_in 'Baujahr', :with => 1956
          end
        end

        it 'saves a new Figure' do
          click_on 'Zahlen und Fakten erstellen'
          @real_estate.reload
          @real_estate.figure.should be_a(Figure)
        end

        context '#create' do
          before :each do
            click_on 'Zahlen und Fakten erstellen'
            @real_estate.reload
            @figure = @real_estate.figure
          end

          it 'has saved the provided attributes' do
            @figure.floor.should == -1
            @figure.floor_estimate.should == 'UG. - 2.OG'
            @figure.rooms.should ==  '3.5'
            @figure.rooms_estimate.should == '3 - 3.5 Zimmer'
            @figure.living_surface.should == '124.6'
            @figure.living_surface_estimate.should == '124.6 - 130.4m2'
            @figure.property_surface.should == '400.5'
            @figure.usable_surface.should == '200.6'
            @figure.ceiling_height.should == '2.6'
            @figure.floors.should == 3
            @figure.renovated_on.should == 1997
            @figure.built_on.should == 1956
          end
        end
      end
    end
  end

  context 'in a real estate with commercial utilization' do
    describe '#new' do
      before :each do
        @real_estate = Fabricate(:real_estate,
          :utilization => RealEstate::UTILIZATION_COMMERICAL,
          :category => Category.last, 
          :reference => Fabricate.build(:reference)
        )
        visit edit_cms_real_estate_path(@real_estate)
        click_on 'Zahlen und Fakten'
      end

      it 'opens the create form' do
        current_path.should == new_cms_real_estate_figure_path(@real_estate)
      end

      context 'a valid Figure' do
        before :each do
          within(".new_figure") do
            fill_in 'Stockwerk', :with => '-1'
            fill_in 'Stockwerk ungefähr', :with => 'UG. - 2.OG'
            fill_in 'Anzahl Zimmer', :with => '3.5'
            fill_in 'Anzahl Zimmer ungefähr', :with => '3 - 3.5 Zimmer'
            fill_in 'Wohnfläche', :with => '124.6'
            fill_in 'Wohnfläche ungefähr', :with => '124.6 - 130.4m2'
            fill_in 'Grundstückfläche', :with => '400.5'
            fill_in 'Nutzfläche', :with => '200.6'
            fill_in 'Lagerfläche', :with => '150'
            fill_in 'Raumhöhe', :with => '2.6'
            fill_in 'Anzahl Stockwerke', :with => 3
            fill_in 'Renovationsjahr', :with => 1997
            fill_in 'Baujahr', :with => 1956
          end
        end

        it 'saves a new Figure' do
          click_on 'Zahlen und Fakten erstellen'
          @real_estate.reload
          @real_estate.figure.should be_a(Figure)
        end

        context '#create' do
          before :each do
            click_on 'Zahlen und Fakten erstellen'
            @real_estate.reload
            @figure = @real_estate.figure
          end

          it 'has saved the provided attributes' do
            @figure.floor.should == -1
            @figure.floor_estimate.should == 'UG. - 2.OG'
            @figure.rooms.should ==  '3.5'
            @figure.rooms_estimate.should == '3 - 3.5 Zimmer'
            @figure.living_surface.should == '124.6'
            @figure.living_surface_estimate.should == '124.6 - 130.4m2'
            @figure.property_surface.should == '400.5'
            @figure.usable_surface.should == '200.6'
            @figure.storage_surface.should == '150'
            @figure.ceiling_height.should == '2.6'
            @figure.floors.should == 3
            @figure.renovated_on.should == 1997
            @figure.built_on.should == 1956
          end
        end
      end
    end
  end


  describe '#show' do
     let :real_estate do
       Fabricate :real_estate, :category => Fabricate(:category), :figure => Fabricate.build(:figure)
     end

     let :real_estate_without_figure do
       Fabricate :real_estate, :category => Fabricate(:category)
     end

     it 'shows the figure within the cms' do
       visit cms_real_estate_figure_path real_estate
       [:floor,:rooms,:living_surface].each do |attr|
         page.should have_content real_estate.figure.send(attr)
       end
     end

     it 'shows a message if no figure exist' do
       visit cms_real_estate_figure_path real_estate_without_figure
       page.should have_content "Für diese Immobilie wurden keine Zahlen und Fakten hinterlegt."
     end

  end

end
