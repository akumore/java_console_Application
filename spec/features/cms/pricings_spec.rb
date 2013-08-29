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

        it 'shows the storage price input' do
          page.should have_css('#pricing_storage')
        end

        it 'shows the extra_storage price input' do
          page.should have_css('#pricing_extra_storage')
        end

        it 'shows right parking spots pricing group title' do
          page.should have_content('Mietzins für Parkplätze')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Netto Miete', :with => '1500'
              fill_in 'Nebenkosten', :with => '50'
              select 'pro Mt.', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'pricing_inside_parking', :with => '140'
                fill_in 'pricing_outside_parking', :with => '160'
                fill_in 'pricing_double_garage', :with => '200'
                fill_in 'pricing_single_garage', :with => '150'
                fill_in 'pricing_outdoor_bike', :with => '120'
                fill_in 'pricing_covered_bike', :with => '145'
                fill_in 'pricing_covered_slot', :with => '155'
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
              @pricing.additional_costs.should == 50
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

          context 'when selecting per square meter per month price unit' do
            context 'when javascript is enabled', :js => true do
              before :each do
                select 'pro m²/J.', :from => 'Preiseinheit'
              end

              it 'shows the monthly prices container' do
                page.should have_css('.monthly-prices-container:not(.hidden)')
              end
            end

            context 'a valid monthly pricing' do
              before :each do
                select 'pro m²/J.', :from => 'Preiseinheit'
                fill_in 'Netto Miete', :with => '565'
                fill_in 'Nebenkosten', :with => '566'

                within('.general.monthly-prices-container') do
                  fill_in 'pricing_for_rent_netto_monthly', :with => '567'
                  fill_in 'pricing_estimate_monthly', :with => '568'
                  fill_in 'pricing_additional_costs_monthly', :with => '569'
                end
              end

              it 'saves a new monthly year_m2 Pricing' do
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

                it 'has saved the provided monthly general year_m2 attributes' do
                  @pricing.for_rent_netto_monthly.should == 567
                  @pricing.estimate_monthly.should == '568'
                  @pricing.additional_costs_monthly.should == 569
                  @pricing.price_unit.should ==  'year_m2'
                end
              end
            end
          end
        end
      end

      describe '#show' do
        let :real_estate do
          Fabricate :published_real_estate,
            :category => Fabricate(:category),
            :pricing => Fabricate.build(
              :pricing_for_rent,
              :estimate => 10,
              :inside_parking => 123
            )
        end

        it 'shows the prices within the cms' do
          visit cms_real_estate_pricing_path real_estate
          {
            :price_unit       => I18n.t("cms.pricings.form.#{real_estate.pricing.price_unit}"),
            :for_rent_netto   => number_to_currency(real_estate.pricing.for_rent_netto, :locale => 'de-CH'),
            :estimate         => real_estate.pricing.estimate,
            :additional_costs => number_to_currency(real_estate.pricing.additional_costs, :locale => 'de-CH'),
            :storage          => number_to_currency(real_estate.pricing.storage, :locale => 'de-CH'),
            :extra_storage    => number_to_currency(real_estate.pricing.extra_storage, :locale => 'de-CH')
          }.each do |attr, expected_text|
            attr_name = Pricing.human_attribute_name(attr)
            find(:xpath, "//dl/dt[contains(string(), '#{attr_name}')]/following-sibling::dd").should have_content(expected_text)
          end
        end

        it 'shows the per month prices container' do
          real_estate.pricing.update_attributes(:price_unit => 'year_m2', :for_rent_netto_monthly => 123, :additional_costs_monthly => 456)
          visit cms_real_estate_pricing_path real_estate
          page.should have_css('.monthly-prices-container')
          find('.for-rent-netto-monthly').should have_content(123)
          find('.additional-costs-monthly').should have_content(456)
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

        it 'does show the additional costs price input' do
          page.should have_css('#pricing_additional_costs')
        end

        it 'shows the storage price input' do
          page.should have_css('#pricing_storage')
        end

        it 'shows the extra_storage price input' do
          page.should have_css('#pricing_extra_storage')
        end

        it 'shows right parking spots pricing group title' do
          page.should have_content('Kaufpreis für Parkplätze')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Kaufpreis', :with => '100000'
              select 'Kaufpreis', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'pricing_inside_parking', :with => '50000'
                fill_in 'pricing_outside_parking', :with => '10000'
                fill_in 'pricing_double_garage', :with => '20000'
                fill_in 'pricing_single_garage', :with => '15000'
                fill_in 'pricing_outdoor_bike', :with => '11000'
                fill_in 'pricing_covered_bike', :with => '14000'
                fill_in 'pricing_covered_slot', :with => '12000'
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

      describe '#show' do
        let :real_estate do
          Fabricate :published_real_estate,
            :offer => Offer::SALE,
            :category => Fabricate(:category),
            :pricing => Fabricate.build(:pricing_for_sale)
        end

        it 'shows the prices within the cms' do
          visit cms_real_estate_pricing_path real_estate
          {
            :for_sale         => number_to_currency(real_estate.pricing.for_sale, :locale         => 'de-CH'),
            :opted            => I18n.t("#{real_estate.pricing.opted}"),
            :estimate         => real_estate.pricing.estimate,
            :additional_costs => number_to_currency(real_estate.pricing.additional_costs, :locale => 'de-CH'),
            :storage          => number_to_currency(real_estate.pricing.storage, :locale          => 'de-CH'),
            :extra_storage    => number_to_currency(real_estate.pricing.extra_storage, :locale    => 'de-CH')
          }.each do |attr, expected_text|
            attr_name = Pricing.human_attribute_name(attr)
            find(:xpath, "//dl/dt[contains(string(), '#{attr_name}')]/following-sibling::dd").should have_content(expected_text)
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
              fill_in 'Nebenkosten', :with => '150'
              select 'pro J.', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'pricing_inside_parking', :with => '200'
                fill_in 'pricing_outside_parking', :with => '150'
                fill_in 'pricing_double_garage', :with => '300'
                fill_in 'pricing_single_garage', :with => '250'
                fill_in 'pricing_outdoor_bike', :with => '220'
                fill_in 'pricing_covered_bike', :with => '230'
                fill_in 'pricing_covered_slot', :with => '205'
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
              @pricing.additional_costs.should == 150
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

        it 'does show the additional costs price input' do
          page.should have_css('#pricing_additional_costs')
        end

        context 'a valid Pricing' do
          before :each do
            within(".new_pricing") do
              fill_in 'Kaufpreis', :with => '200000'
              fill_in 'Nebenkosten', :with => '150'
              select 'Kaufpreis', :from => 'Preiseinheit'

              within('.parking-spots-prices-group') do
                fill_in 'pricing_inside_parking', :with => '40000'
                fill_in 'pricing_outside_parking', :with => '15000'
                fill_in 'pricing_double_garage', :with => '45000'
                fill_in 'pricing_single_garage', :with => '30000'
                fill_in 'pricing_outdoor_bike', :with => '25000'
                fill_in 'pricing_covered_bike', :with => '27000'
                fill_in 'pricing_covered_slot', :with => '29000'
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
              @pricing.additional_costs.should == 150
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
