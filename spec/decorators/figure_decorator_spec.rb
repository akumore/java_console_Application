# encoding: utf-8
require 'spec_helper'

describe FigureDecorator do
  before { ApplicationController.new.set_current_view_context }

  before :each do
    @real_estate = Fabricate(:published_real_estate,
      :category => Fabricate(:category),
      :utilization => RealEstate::UTILIZATION_PRIVATE,
      :figure => Fabricate.build(:figure,
        :floor => 2,
        :floor_estimate => '',
        :rooms => '3.5',
        :rooms_estimate => '',
        :living_surface => 100,
        :living_surface_estimate => '',
        :usable_surface => 135,
        :property_surface => 145,
        :storage_surface => 155,
        :floors => 2,
        :ceiling_height => '2.55'
      )
    )

    @figure = FigureDecorator.new(@real_estate.figure)
  end

  describe '#floor' do
    it 'formats below ground' do
      @figure.model.update_attribute :floor, -2
      @figure.floor.should == '2. Untergeschoss'
    end

    it 'formats on ground' do
      @figure.model.update_attribute :floor, 0
      @figure.floor.should == 'Erdgeschoss'
    end

    it 'formats above ground' do
      @figure.model.update_attribute :floor, 3
      @figure.floor.should == '3. Obergeschoss'
    end

    it 'renders the estimate value if present' do
      @figure.model.update_attribute :floor_estimate, '2 - 3 Obergeschoss'
      @figure.floor.should == '2 - 3 Obergeschoss'
    end
  end

  describe '#rooms' do
    it 'formats the number of rooms' do
      @figure.rooms.should == '3.5 Zimmer'
    end

    it 'renders the estimate number of rooms if present' do
      @figure.update_attribute :rooms_estimate, '2.5 - 4.5 Zimmer'
      @figure.rooms.should == '2.5 - 4.5 Zimmer'
    end
  end

  describe '#living_surface' do
    it 'formats the size' do
      @figure.living_surface.should == '100 m²'
    end

    it 'renders the estimate living surface if present' do
      @figure.update_attribute :living_surface_estimate, '180 - 190 m²'
      @figure.living_surface.should == '180 - 190 m²'
    end
  end

  it 'formats the usable surface' do
    @figure.usable_surface.should == '135 m²'
  end

  it 'formats the property surface' do
    @figure.property_surface.should == '145 m²'
  end

  it 'formats the size the storage surface' do
    @figure.storage_surface.should == '155 m²'
  end

  it 'formats the ceiling height' do
    @figure.ceiling_height.should == '2.55 m'
  end

  it 'formats the number of floors' do
    @figure.floors.should == '2 Geschosse'
    @figure.update_attribute :floors, 1
    @figure.floors.should == '1 Geschoss'
  end

  context 'for private usage' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :utilization => RealEstate::UTILIZATION_PRIVATE,
        :figure => Fabricate.build(:figure,
          :living_surface => 153,
          :usable_surface => 120
        )
      )

      @figure = FigureDecorator.new(@real_estate.figure)
    end

    describe '#surface' do
      it 'returns the formatted living surface' do
        @figure.update_attribute :living_surface_estimate, ''
        @figure.surface.should == '153 m²'
      end

      it 'returns the estimate living surface' do
        @figure.update_attribute :living_surface_estimate, '80 - 90 m²'
        @figure.surface.should == '80 - 90 m²'
      end
    end
  end


  context 'for commercial usage' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :utilization => RealEstate::UTILIZATION_COMMERICAL,
        :figure => Fabricate.build(:figure,
          :living_surface => 153,
          :usable_surface => 120
        )
      )

      @figure = FigureDecorator.new(@real_estate.figure)
    end

    describe '#surface' do
      it 'returns the formatted usable surface' do
        @figure.surface.should == '120 m²'
      end
    end
  end
end
