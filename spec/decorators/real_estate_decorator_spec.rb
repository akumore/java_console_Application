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
      :additional_description,
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
        :infrastructure => Fabricate.build(:infrastructure),
        :additional_description => AdditionalDescription.new
      )
      @decorator = RealEstateDecorator.new(real_estate)
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

  describe 'north arrow overlay' do

    let(:real_estate) do
      RealEstateDecorator.decorate Fabricate(:residential_building)
    end

    context "When additional_description is present" do
      context "When orientation_degrees is present" do
        context "and correct" do
          it "should render round orientation" do
            real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 183)
            real_estate.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*180/
          end

          it "should render round orientation" do
            real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 191.9)
            real_estate.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*190/
          end
        end

        context "and incorrect" do
          it "should render orientation 0 degrees" do
            real_estate.additional_description = Fabricate.build(:additional_description, :orientation_degrees => 'foobar')
            real_estate.north_arrow_overlay.should =~ /north-arrow-container.*img.*src.*0/
          end
        end
      end

      context "and orientation_degrees is blank" do
        it "does not return the north arrow overlay" do
          real_estate.north_arrow_overlay.should == nil
        end
      end
    end

  end
end
