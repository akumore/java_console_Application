# encoding: utf-8
require "spec_helper"

describe "RealEstates Figures" do
  monkey_patch_default_url_options

  let :category do
    Fabricate(:category, :label => 'Wohnung')
  end

  let :real_estate do
    Fabricate :published_real_estate,
              :category => category,
              :channels => [RealEstate::WEBSITE_CHANNEL, RealEstate::PRINT_CHANNEL],
              :address => Fabricate.build(:address),
              :information => Fabricate.build(:information),
              :figure => Fabricate.build(:figure, :rooms => 10.5, :floor => 99),
              :pricing => Fabricate.build(:pricing),
              :infrastructure => Fabricate.build(:infrastructure),
              :additional_description => Fabricate.build(:additional_description),
              :contact => Fabricate(:employee)
  end

  describe '#ceiling_height' do
    context 'with living utilization' do
      it "doesn't shows ceiling height" do
        real_estate.update_attribute(:utilization, Utilization::LIVING)
        visit real_estate_path(real_estate)
        page.should_not have_content('Raumhöhe')
      end
    end

    context 'with working utilization' do
      it "shows ceiling height" do
        real_estate.update_attribute(:utilization, Utilization::WORKING)
        visit real_estate_path(real_estate)
        page.should have_content('Raumhöhe')
      end
    end

    context 'with storing utilization' do
      it "shows ceiling height" do
        real_estate.update_attribute(:utilization, Utilization::STORING)
        visit real_estate_path(real_estate)
        page.should have_content('Raumhöhe')
      end
    end

    context 'with parking utilization' do
      it "doesn't shows ceiling height" do
        real_estate.update_attribute(:utilization, Utilization::PARKING)
        visit real_estate_path(real_estate)
        page.should_not have_content('Raumhöhe')
      end
    end
  end
end
