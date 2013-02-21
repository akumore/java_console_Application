# encoding: utf-8
require 'spec_helper'

describe "Cms::Pricings" do
  login_cms_user
  create_category_tree

  context 'in a real estate with private utilization' do
    context 'for rent' do
      describe '#new' do
        before :each do
          @real_estate = Fabricate(:real_estate,
            :utilization => Utilization::LIVING,
            :offer => Offer::RENT,
            :category => Category.last,
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@real_estate)
          click_on 'Preise'
        end

        it 'opens the create form' do
          current_path.should == new_cms_real_estate_pricing_path(@real_estate)
        end

        it 'does not show the sale price input' do
          page.should_not have_css('#pricing_for_sale')
        end

        it 'does not show the storage price input' do
          page.should_not have_css('#pricing_storage')
        end

        it 'does not show the extra_storage price input' do
          page.should_not have_css('#pricing_extra_storage')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Netto Miete', :with => '1500'
              fill_in 'Mietnebenkosten', :with => '50'
              fill_in 'Mietzinsdepot', :with => '4500'
              select 'pro Monat', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'Parkplatz in Autoeinstellhalle', :with => '140'
                fill_in 'Parkplatz im Freien', :with => '160'
                fill_in 'Doppelgarage', :with => '200'
                fill_in 'Einzelgarage', :with => '150'
                fill_in 'Motorrad-Parkplatz im Freien überdacht', :with => '120'
                fill_in 'Motorrad-Parkplatz in Autoeinstellhalle', :with => '145'
                fill_in 'Parkplatz im Freien überdacht', :with => '155'
              end

              fill_in 'Ungefährer Preis', :with => '1500 - 2000.-'
              check('Optiert')
            end
          end

          it 'saves a new Pricing' do
            click_on 'Preise erstellen'
            @real_estate.reload
            @real_estate.pricing.should be_a(Pricing)
          end

          context '#create' do
            before :each do
              click_on 'Preise erstellen'
              @real_estate.reload
              @pricing = @real_estate.pricing
            end

            it 'has saved the provided attributes' do
              @pricing.for_rent_netto.should == 1500
              @pricing.for_rent_extra.should == 50
              @pricing.for_rent_depot.should == 4500
              @pricing.price_unit.should ==  'monthly'
              @pricing.inside_parking.should == 140
              @pricing.outside_parking.should == 160
              @pricing.double_garage.should == 200
              @pricing.single_garage.should == 150
              @pricing.outdoor_bike.should == 120
              @pricing.covered_bike.should == 145
              @pricing.covered_slot.should == 155
              @pricing.estimate.should == '1500 - 2000.-'
              @pricing.opted.should be_true
            end
          end
        end
      end
    end

    context 'for sale' do
      describe '#new' do
        before :each do
          @real_estate = Fabricate(:real_estate,
            :utilization => Utilization::LIVING,
            :offer => Offer::SALE,
            :category => Category.last,
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@real_estate)
          click_on 'Preise'
        end

        it 'opens the create form' do
          current_path.should == new_cms_real_estate_pricing_path(@real_estate)
        end

        it 'does show the price unit' do
          page.should have_css('#pricing_price_unit')
        end

        it 'does not show the rent price input' do
          page.should_not have_css('#pricing_for_rent')
        end

        it 'does not show the rent extra price input' do
          page.should_not have_css('#pricing_for_rent_extra')
        end

        it 'does not show the storage price input' do
          page.should_not have_css('#pricing_storage')
        end

        it 'does not show the extra_storage price input' do
          page.should_not have_css('#pricing_extra_storage')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Kaufpreis', :with => '100000'
              select 'Verkaufspreis', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'Parkplatz in Autoeinstellhalle', :with => '50000'
                fill_in 'Parkplatz im Freien', :with => '10000'
                fill_in 'Doppelgarage', :with => '20000'
                fill_in 'Einzelgarage', :with => '15000'
                fill_in 'Motorrad-Parkplatz im Freien überdacht', :with => '11000'
                fill_in 'Motorrad-Parkplatz in Autoeinstellhalle', :with => '14000'
                fill_in 'Parkplatz im Freien überdacht', :with => '12000'
              end

              fill_in 'Ungefährer Preis', :with => '10000 - 200000.-'
              check('Optiert')
            end
          end

          it 'saves a new Pricing' do
            click_on 'Preise erstellen'
            @real_estate.reload
            @real_estate.pricing.should be_a(Pricing)
          end

          context '#create' do
            before :each do
              click_on 'Preise erstellen'
              @real_estate.reload
              @pricing = @real_estate.pricing
            end

            it 'has saved the provided attributes' do
              @pricing.for_sale.should == 100000
              @pricing.price_unit.should == 'sell'
              @pricing.inside_parking.should == 50000
              @pricing.outside_parking.should == 10000
              @pricing.double_garage.should == 20000
              @pricing.single_garage.should == 15000
              @pricing.outdoor_bike.should == 11000
              @pricing.covered_bike.should == 14000
              @pricing.covered_slot.should == 12000
              @pricing.estimate.should == '10000 - 200000.-'
              @pricing.opted.should be_true
            end
          end
        end
      end
    end
  end

  context 'in a real estate with commercial utilization' do
    context 'for rent' do
      describe '#new' do
        before :each do
          @real_estate = Fabricate(:real_estate,
            :utilization => Utilization::WORKING,
            :offer => Offer::RENT,
            :category => Category.last,
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@real_estate)
          click_on 'Preise'
        end

        it 'opens the create form' do
          current_path.should == new_cms_real_estate_pricing_path(@real_estate)
        end

        it 'does not show the sale price input' do
          page.should_not have_css('#pricing_for_sale')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Netto Miete', :with => '2300'
              fill_in 'Mietnebenkosten', :with => '150'
              fill_in 'Mietzinsdepot', :with => '6000'
              select 'pro Jahr', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'Parkplatz in Autoeinstellhalle', :with => '200'
                fill_in 'Parkplatz im Freien', :with => '150'
                fill_in 'Doppelgarage', :with => '300'
                fill_in 'Einzelgarage', :with => '250'
                fill_in 'Motorrad-Parkplatz im Freien überdacht', :with => '220'
                fill_in 'Motorrad-Parkplatz in Autoeinstellhalle', :with => '230'
                fill_in 'Parkplatz im Freien überdacht', :with => '205'
              end

              fill_in 'Lagerpreis', :with => '200'
              fill_in 'Lager Nebenkosten', :with => '50'

              fill_in 'Ungefährer Preis', :with => '2500 - 2500.-'
              check('Optiert')
            end
          end

          it 'saves a new Pricing' do
            click_on 'Preise erstellen'
            @real_estate.reload
            @real_estate.pricing.should be_a(Pricing)
          end

          context '#create' do
            before :each do
              click_on 'Preise erstellen'
              @real_estate.reload
              @pricing = @real_estate.pricing
            end

            it 'has saved the provided attributes' do
              @pricing.for_rent_netto.should == 2300
              @pricing.for_rent_extra.should == 150
              @pricing.for_rent_depot.should == 6000
              @pricing.price_unit.should ==  'yearly'
              @pricing.inside_parking.should == 200
              @pricing.outside_parking.should == 150
              @pricing.double_garage.should == 300
              @pricing.single_garage.should == 250
              @pricing.outdoor_bike.should == 220
              @pricing.covered_bike.should == 230
              @pricing.covered_slot.should == 205
              @pricing.storage.should == 200
              @pricing.extra_storage.should == 50
              @pricing.estimate.should == '2500 - 2500.-'
              @pricing.opted.should be_true
            end
          end
        end
      end
    end

    context 'for sale' do
      describe '#new' do
        before :each do
          @real_estate = Fabricate(:real_estate,
            :utilization => Utilization::WORKING,
            :offer => Offer::SALE,
            :category => Category.last,
            :reference => Fabricate.build(:reference)
          )
          visit edit_cms_real_estate_path(@real_estate)
          click_on 'Preise'
        end

        it 'opens the create form' do
          current_path.should == new_cms_real_estate_pricing_path(@real_estate)
        end

        it 'does show the price unit' do
          page.should have_css('#pricing_price_unit')
        end

        it 'does not show the rent price input' do
          page.should_not have_css('#pricing_for_rent')
        end

        it 'does not show the rent extra price input' do
          page.should_not have_css('#pricing_for_rent_extra')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Kaufpreis', :with => '200000'
              select 'Verkaufspreis', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'Parkplatz in Autoeinstellhalle', :with => '40000'
                fill_in 'Parkplatz im Freien', :with => '15000'
                fill_in 'Doppelgarage', :with => '45000'
                fill_in 'Einzelgarage', :with => '30000'
                fill_in 'Motorrad-Parkplatz im Freien überdacht', :with => '25000'
                fill_in 'Motorrad-Parkplatz in Autoeinstellhalle', :with => '27000'
                fill_in 'Parkplatz im Freien überdacht', :with => '29000'
              end

              fill_in 'Lagerpreis', :with => '100000'
              fill_in 'Lager Nebenkosten', :with => '2000'

              fill_in 'Ungefährer Preis', :with => '150000 - 1800000.-'
              check('Optiert')
            end
          end

          it 'saves a new Pricing' do
            click_on 'Preise erstellen'
            @real_estate.reload
            @real_estate.pricing.should be_a(Pricing)
          end

          context '#create' do
            before :each do
              click_on 'Preise erstellen'
              @real_estate.reload
              @pricing = @real_estate.pricing
            end

            it 'has saved the provided attributes' do
              @pricing.for_sale.should == 200000
              @pricing.price_unit.should == 'sell'
              @pricing.inside_parking.should == 40000
              @pricing.outside_parking.should == 15000
              @pricing.double_garage.should == 45000
              @pricing.single_garage.should == 30000
              @pricing.outdoor_bike.should == 25000
              @pricing.covered_bike.should == 27000
              @pricing.covered_slot.should == 29000
              @pricing.estimate.should == '150000 - 1800000.-'
              @pricing.storage.should == 100000
              @pricing.extra_storage == 2000
              @pricing.opted.should be_true
            end
          end
        end
      end
    end
  end
end
