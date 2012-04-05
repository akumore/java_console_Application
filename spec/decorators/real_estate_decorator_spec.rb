require 'spec_helper'

describe RealEstateDecorator do
  # workaround for issue: https://github.com/jcasimir/draper/issues/60
  include Rails.application.routes.url_helpers
  before :all do
    c = ApplicationController.new
    c.request = ActionDispatch::TestRequest.new
    c.set_current_view_context
  end
  # end of workaround

  describe 'an invalid real estate' do
    before :each do
      real_estate = RealEstate.new
      @decorator = RealEstateDecorator.new(real_estate)
    end

    [
      :short_info_address,
      :short_info_price,
      :short_info_figure,
      :short_info_size,
      :additional_description,
      :mini_doku_link,
      :information_shared,
      :information_basic,
      :price_info_basic,
      :price_info_parking,
      :facts_and_figures,
      :infrastructure_parking,
      :infrastructure_distances,
      :reference_project_caption
    ].each do |accessor|
      it "calling #{accessor} doesnt raise an exception with invalid data" do
        expect { @decorator.send(accessor) }.to_not raise_error
      end
    end
  end

  describe 'a valid real estate' do
    before :each do
      real_estate = Fabricate(:real_estate,
        :category => Fabricate(:category, :name=>'single_house', :label=>'Einfamilienhaus'),
        :reference => Reference.new,
        :address => Fabricate.build(:address),
        :information => Information.new,
        :pricing => Fabricate.build(:pricing),
        :figure => Fabricate.build(:figure),
        :infrastructure => Fabricate.build(:infrastructure),
        :additional_description => AdditionalDescription.new
      )
      @decorator = RealEstateDecorator.new(real_estate)
    end

    [
      :information_shared,
      :information_basic,
      :price_info_basic,
      :price_info_parking,
      :facts_and_figures,
      :infrastructure_parking,
      :infrastructure_distances
    ].each do |accessor|
      it "#{accessor} returns an array of printable properties" do
        @decorator.send(accessor).should be_a(Array)
      end
    end
  end

  describe '#reference_project_caption' do
    context 'with a link in the address' do
      it 'links to the provided url' do
        real_estate = Fabricate(:real_estate, 
          :address => Fabricate.build(:address, :link_url => 'http://www.google.ch'),
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference)
        )
        decorator = RealEstateDecorator.new(real_estate)
        decorator.reference_project_caption.should include('http://www.google.ch')
      end
    end

    context 'without a link in the addres' do
      
      it 'shows no link' do
        real_estate = Fabricate(:real_estate, 
          :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL],
          :address => Fabricate.build(:address, :link_url => ''),
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference)
        )
        decorator = RealEstateDecorator.new(real_estate)
        decorator.reference_project_caption.should_not include(I18n.t('real_estates.reference_projects.link_title'))
      end

      context 'when enabled for the website channel' do
        it 'links to the detail page' do
          pending 'figure out how draper handles this issue: https://github.com/jcasimir/draper/issues/116'

          real_estate = Fabricate(:real_estate, 
          :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL, RealEstate::WEBSITE_CHANNEL],
          :address => Fabricate.build(:address, :link_url => ''),
          :category => Fabricate(:category),
          :reference => Fabricate.build(:reference)
        )
        decorator = RealEstateDecorator.new(real_estate)
        decorator.reference_project_caption.should include(I18n.t('real_estates.reference_projects.link_title'))
        decorator.reference_project_caption.should include(real_estate_path(real_estate))
        end
      end
    end
  end
end
