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

              within('.inside-parking') do
                fill_in 'Permanent', :with => '140'
                fill_in 'Temporär', :with => '100'
              end

              within('.outside-parking') do
                fill_in 'Permanent', :with => '160'
                fill_in 'Temporär', :with => '80'
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
              @pricing.inside_parking_temporary.should == 100
              @pricing.outside_parking_temporary.should == 80
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

              within('.inside-parking') do
                fill_in 'Permanent', :with => '50000'
                fill_in 'Temporär', :with => '1000'
              end

              within('.outside-parking') do
                fill_in 'Permanent', :with => '10000'
                fill_in 'Temporär', :with => '800'
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
              @pricing.inside_parking_temporary.should == 1000
              @pricing.outside_parking_temporary.should == 800
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

              within('.inside-parking') do
                fill_in 'Permanent', :with => '200'
                fill_in 'Temporär', :with => '90'
              end

              within('.outside-parking') do
                fill_in 'Permanent', :with => '150'
                fill_in 'Temporär', :with => '100'
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
              @pricing.inside_parking_temporary.should == 90
              @pricing.outside_parking_temporary.should == 100
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

              within('.inside-parking') do
                fill_in 'Permanent', :with => '40000'
                fill_in 'Temporär', :with => '2000'
              end

              within('.outside-parking') do
                fill_in 'Permanent', :with => '15000'
                fill_in 'Temporär', :with => '1200'
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
              @pricing.inside_parking_temporary.should == 2000
              @pricing.outside_parking_temporary.should == 1200
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
