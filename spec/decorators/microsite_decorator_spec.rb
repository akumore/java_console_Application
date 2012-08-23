# encoding: utf-8

require 'spec_helper'

describe MicrositeDecorator do
  context "When the number of rooms is defined" do

    before do
      @real_estate =  Fabricate :residential_building,
        :figure => Fabricate.build(:figure, :rooms => '1.5')
      @decorated_real_estate = MicrositeDecorator.decorate @real_estate
    end

    it 'returns the correct value' do
      @decorated_real_estate.rooms.should == '1.5'
    end
  end

  context "with correct net price" do

    it 'returns the rendered net price' do
      real_estate =  Fabricate :residential_building,
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 2500)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should == 'CHF 2\'500.00 / Monat'
    end

  end

  context "with incorrect net price" do

    it 'returns the net rent price without extras' do
      real_estate =  Fabricate :residential_building,
        :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 2500, :for_rent_extra => 200)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should == 'CHF 2\'500.00 / Monat'
    end

    it 'returns nil if no pricing is specified' do
      real_estate =  Fabricate :residential_building,
        :pricing => nil
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should be_nil
    end

    it 'returns nil if no for_rent_netto is specified' do
      real_estate =  Fabricate :residential_building
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.price.should be_nil
    end
  end

  context "with correct address" do

    it 'returns the corresponding house-name' do
      for street_number, house_name in MicrositeDecorator::STREET_NUMBER_HOUSE_MAP
        street = "Badenerstrasse"
        real_estate =  Fabricate :residential_building,
          :address => Fabricate.build(:address, :street => street, :street_number => street_number)
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.house.should == house_name
      end
    end
  end

  context "with incorrect address" do

    it 'returns nil for unmapped address' do
      real_estate =  Fabricate :residential_building,
        :address => Fabricate.build(:address, :street => 'Büchsenweg', :street_number => 30)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.house.should be_nil
    end
  end

  context "with assigned floor number" do

    it 'returns the rendered floor name' do
      for floor, floor_label in MicrositeDecorator::FLOOR_FLOOR_LABEL_MAP
        real_estate =  Fabricate :residential_building,
          :figure => Fabricate.build(:figure, :floor => floor)
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.floor_label.should == floor_label
      end
    end
  end

  context "with a valid surface" do
    context "for a residential building" do

      it 'returns the living surface' do
        real_estate =  Fabricate :residential_building,
          :figure => Fabricate.build(:figure, :living_surface => '50')
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.surface.should == '50 m²'
      end
    end

    context "for a commercial building" do

      it 'returns the usable surface' do
        real_estate =  Fabricate :commercial_building,
          :figure => Fabricate.build(:figure, living_surface: nil, :usable_surface => '50')
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.surface.should == '50 m²'
      end
    end
  end


  context "group" do
    it 'delegates to get_group in Microsite::GroupRealEstates' do
      real_estate =  Fabricate :residential_building
      Microsite::GroupRealEstates.should_receive(:get_group).with(real_estate).
        and_return({:label => 'MYGROUP'})
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.group.should == 'MYGROUP'
    end
  end

  context 'utilization' do
    context 'for private buildings' do
      it 'returns Wohnen' do
        real_estate =  Fabricate :residential_building
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.utilization.should == 'Wohnen'
      end
    end

    context 'for commercial buildings' do
      it 'returns Arbeiten' do
        real_estate =  Fabricate :commercial_building
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.utilization.should == 'Arbeiten'
      end
    end
  end

  context 'category' do
    it 'returns the category' do
      real_estate =  Fabricate :real_estate, :category => Fabricate(:category, :label => 'my category')
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.category.should == 'my category'
    end
  end

  context "with assigned id" do

    it 'returns model\'s id' do
      real_estate =  Fabricate :real_estate, :category => Fabricate(:category)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.id.should == real_estate.id
    end
  end

  context "with title" do
    it 'returns the title' do
      real_estate =  Fabricate :real_estate, :title => 'my title', :category=>Fabricate(:category)
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.title.should == 'my title'
    end
  end

  context "floorplans" do

    let :real_estate do
      real_estate =  Fabricate :residential_building, :floor_plans => [Fabricate.build(:media_assets_floor_plan)]
    end

    let :decorated_real_estate do
      decorated_real_estate = MicrositeDecorator.decorate real_estate
      decorated_real_estate.stub(:path_to_url => 'link', :real_estate_floorplan_path => '')
      decorated_real_estate
    end

    context "returns the list of floor plans" do
      it "returns all floor plans" do
        decorated_real_estate.floorplans.should include({
          :url => "link",
          :url_full_size => "link",
          :url_full_size_image => "link",
          :title => "Floor plan title"
        })
      end

      it "with title and absolute image url" do
        title = 'my title'
        real_estate.floor_plans.first.title = title
        decorated_real_estate.floorplans.first[:title].should == title
      end

      it "should call path_to_url for each image link" do
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.stub(:real_estate_floorplan_path => '')
        decorated_real_estate.should_receive(:path_to_url).exactly(3).times.and_return('http://abosute_url')
        decorated_real_estate.floorplans
      end

    end

    context "with orientation set" do
      let :real_estate do
        real_estate =  Fabricate :residential_building,
          :floor_plans => [Fabricate.build(:media_assets_floor_plan)],
          :additional_description => Fabricate.build(:additional_description, :orientation_degrees => 293)
      end

      it "adds the north-arrow image link to the returned hash" do
        decorated_real_estate.floorplans.first[:north_arrow].should_not be_nil
      end

      it "should call path_to_url for each image link and the north arrow" do
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.stub(:real_estate_floorplan_path => '')
        decorated_real_estate.should_receive(:path_to_url).exactly(4).times.and_return('http://abosute_url')
        decorated_real_estate.floorplans
      end
    end

    context "without orientation set" do
      it "does not add the north-arrow image link to the returned hash" do
        decorated_real_estate.floorplans.first[:north_arrow].should be_nil
      end
    end
  end

  context "as json" do

    it 'returns only the selected attributes' do
      real_estate =  Fabricate :commercial_building, :figure => Fabricate.build(:figure)
        decorated_real_estate = MicrositeDecorator.decorate real_estate
        decorated_real_estate.stub(:real_estate_handout_path => '', :path_to_url => '')
        got = ['_id', 'title', 'rooms', 'floor_label', 'house', 'surface', 'price', 'group', 'utilization', 'category', 'chapters', 'floorplans', 'images', 'downloads']
        decorated_real_estate.as_json.keys.should == got
    end
  end


  describe "Order real estates" do
    it "orders by groups/categories" do
      @loft = MicrositeDecorator.new(Fabricate :real_estate, :category => Fabricate(:category, :label => 'Loft'), :figure => Fabricate.build(:figure))
      @commercial = MicrositeDecorator.new(Fabricate :commercial_building, :category => Fabricate(:category, :label => 'Atelier'), :figure => Fabricate.build(:figure))
      @category = Fabricate(:category, :label => 'Wohnung')
      @small = MicrositeDecorator.new(Fabricate :real_estate, :figure => Fabricate.build(:figure, :rooms => '2.5'), :category => @category)
      @medium = MicrositeDecorator.new(Fabricate :real_estate, :figure => Fabricate.build(:figure, :rooms => '3.5'), :category => @category)
      @large = MicrositeDecorator.new(Fabricate :real_estate, :figure => Fabricate.build(:figure, :rooms => '4.5'), :category => @category)

      [@large, @medium, @small, @commercial, @loft].sort.should == [@small, @medium, @large, @loft, @commercial]
    end

    describe "Inner order of a group of real estates" do
      let :flat do
        Fabricate(:category, :label => 'Wohnung')
      end

      let :real_estate_a do
        MicrositeDecorator.new(Fabricate.build :real_estate,
                                               :figure => Fabricate.build(:figure, :rooms => '2.5'),
                                               :category => flat)
      end

      let :real_estate_b do
        MicrositeDecorator.new(Fabricate.build :real_estate,
                                               :figure => Fabricate.build(:figure, :rooms => '2.5'),
                                               :category => flat)
      end

      it "orders by house index alphabetically asc" do
        real_estate_a.to_model.address = Fabricate.build(:address, :street => 'Badenerstrasse', :street_number => '26')
        real_estate_b.to_model.address = Fabricate.build(:address, :street => 'Badenerstrasse', :street_number => '28')

        [real_estate_a, real_estate_b].sort.should == [real_estate_b, real_estate_a]
      end

      describe "Inner order of real estates within the same house" do
        before do
          real_estate_a.to_model.address = Fabricate.build(:address, :street => 'Badenerstrasse', :street_number => '26')
          real_estate_b.to_model.address = Fabricate.build(:address, :street => 'Badenerstrasse', :street_number => '26')
        end

        it "orders by surface asc" do
          real_estate_a.to_model.figure.living_surface = 60
          real_estate_b.to_model.figure.living_surface = 100
          [real_estate_b, real_estate_a].sort.should == [real_estate_a, real_estate_b]
        end

        describe "inner order of real estates having the same surface" do
          it "orders by floor asc" do
            real_estate_a.to_model.figure.floor = -1
            real_estate_b.to_model.figure.floor = 2
            [real_estate_b, real_estate_a].sort.should == [real_estate_a, real_estate_b]
          end
        end
      end
    end
  end

end
