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
      :short_info_detail_first,
      :short_info_detail_second,
      :short_info_detail_third,
      :short_info_detail_fourth,
      :utilization_description,
      :seo_description,
      :mini_doku_link,
      :handout_order_link,
      :floorplan_print_link,
      :project_website_link,
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
      )
      @decorator = RealEstateDecorator.new(real_estate)
    end
  end

  describe '#project_website_link' do

    subject { Fabricate.build(:real_estate, :link_url => 'www.example.com').decorate }

    it 'add http' do
      subject.model.link_url = 'www.example.com'
      subject.project_website_link.should include('http://www.example.com')
    end

    it 'keep http' do
      subject.model.link_url = 'http://www.example.com'
      subject.project_website_link.should include('http://www.example.com')
    end

  end

  describe '#thumbnail', :thumb => true do
    let :decorated_real_estate do
      r = RealEstateDecorator.decorate(mock_model(RealEstate,
                                       :for_rent? => false,
                                       :for_sale? => true,
                                       :living? => true,
                                       :working? => false,
                                       :parking? => false,
                                       :storing? => false
                                       ))
      r.stub_chain(:images, :primary, :file, :thumb, :url).and_return('assets/my_image.jpg')
      r
    end

    it 'returns the thumbnail of the first image' do
      decorated_real_estate.thumbnail.should == 'assets/my_image.jpg'
    end

    context 'parking utilization' do
      it 'returns the icon thumbnail' do
        decorated_real_estate.stub(:parking?).and_return(true)
        decorated_real_estate.stub_chain(:category, :name).and_return('open_slot')
        decorated_real_estate.thumbnail.should == '/assets/parking_thumbnails/open_slot.jpg'
      end
    end
  end

  describe '#object_documentation_title' do
    it 'is generated from the title' do
      real_estate = RealEstate.new :title => 'My Handout'
      RealEstateDecorator.new(real_estate).object_documentation_title.should == 'Objektdokumentation-my-handout'
    end
  end

  describe '#utilization_description' do

    context 'no utilization_description is filled in' do
      real_estate = Fabricate(:real_estate,
        :category => Fabricate.build(:category, :name => 'single_house', :label => 'Einfamilienhaus'),
        :utilization_description => ''
      )
      it 'returns the category label' do
        expect(RealEstateDecorator.new(real_estate).utilization_description).to eq(RealEstateDecorator.new(real_estate).category.label)
      end
    end

    context 'utilization_description is filled in' do
      context 'category label is already included in the utilization_description' do
        it 'returns the unified utilization_description with category label prefixed when category label is placed at the beginning' do
          real_estate = Fabricate(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Haus'),
            :utilization_description => 'Haus, Sweet / Home'
          )
          expect(RealEstateDecorator.new(real_estate).utilization_description).to eq 'Haus/Sweet/Home'
        end

        it 'returns the unified utilization_description with category label prefixed when category label is placed somewhere in the middle' do
          real_estate = Fabricate(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Haus'),
            :utilization_description => 'Sweet/Haus , Home'
          )
          expect(RealEstateDecorator.new(real_estate).utilization_description).to eq 'Haus/Sweet/Home'
        end

        it 'returns the unified utilization_description with category label prefixed when category label is placed at the end' do
          real_estate = Fabricate(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Haus'),
            :utilization_description => 'Sweet/ Home ,Haus'
          )
          expect(RealEstateDecorator.new(real_estate).utilization_description).to eq 'Haus/Sweet/Home'
        end
      end

      context 'category label is not included in the utilization_description' do
        it 'returns the utilization_description separated by "/" and prefixed by the category label' do
          real_estate = Fabricate(:real_estate,
            :category => Fabricate.build(:category, :name => 'single_house', :label => 'Einfamilienhaus'),
            :utilization_description => 'Home, Sweet / Home'
          )
          expect(RealEstateDecorator.new(real_estate).utilization_description).to eq 'Einfamilienhaus/Home/Sweet/Home'
        end
      end
    end
  end

  describe '#channels_string' do
    let(:real_estate) do
      RealEstateDecorator.decorate Fabricate(:residential_building, :print_channel_method => RealEstate::PRINT_CHANNEL_METHOD_PDF_DOWNLOAD)
    end

    it 'returns comma separated channels string "Website, Objektdokumentation (als PDF downloaden)"' do
      expect(real_estate.channels_string).to eq 'Website, Objektdokumentation (als PDF downloaden)'
    end

    context 'order is set for print_channel_method' do
      it 'returns comma separated channels string "Website, Objektdokumentation (bestellen)"' do
        real_estate = RealEstateDecorator.decorate Fabricate(:residential_building, :print_channel_method => RealEstate::PRINT_CHANNEL_METHOD_ORDER)
        expect(real_estate.channels_string).to eq 'Website, Objektdokumentation (bestellen)'
      end
    end

    context 'no print_channel_method is set' do
      it 'returns comma separated channels string "Website, Objektdokumentation" without print_channel_method in brackets' do
        real_estate = RealEstateDecorator.decorate Fabricate(:residential_building, :print_channel_method => '')
        expect(real_estate.channels_string).to eq 'Website, Objektdokumentation'
      end
    end
  end
end
