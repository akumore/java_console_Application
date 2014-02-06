# encoding: utf-8
require 'spec_helper'

describe FigureDecorator do
  before { ApplicationController.new.set_current_view_context }
  let(:field_access) { FieldAccess.new(@real_estate.offer, @real_estate.utilization, FieldAccess.cms_blacklist) }
  before(:each) do Draper::Base.helpers.controller.stub(:field_access) { field_access } end

  let(:figure) do
    Fabricate.build(:figure,
                    :floor => 2,
                    :floor_estimate => '',
                    :rooms => '3.5',
                    :rooms_estimate => '',
                    :living_surface => 100,
                    :living_surface_estimate => '',
                    :usable_surface => 135,
                    :property_surface => 145,
                    :storage_surface => 155,
                    :inside_parking_spots => 1,
                    :outside_parking_spots => 2,
                    :covered_slot => 3,
                    :covered_bike => 4,
                    :outdoor_bike => 5,
                    :single_garage => 6,
                    :double_garage => 7)

  end

  before :each do
    @real_estate = Fabricate(:published_real_estate,
                             :category => Fabricate(:category),
                             :utilization => Utilization::LIVING,
                             :figure => figure)

    @figure = FigureDecorator.new(@real_estate.figure)
  end

  describe '#offer_characteristics' do
    it 'creates an array of characteristics' do
      expect(@figure.offer_characteristics).to eq [
        "1 Parkplatz in Autoeinstellhalle",
        "2 Parkplätze im Freien",
        "3 Parkplätze im Freien überdacht",
        "4 Motorrad-Parkplätze in Autoeinstellhalle",
        "5 Motorrad-Parkplätze im Freien überdacht",
        "6 Einzelgaragen",
        "7 Doppelgaragen"]
    end
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

  describe '#shortened_floor' do
    it 'formats below ground in short form' do
      @figure.model.update_attribute :floor, -2
      expect(@figure.shortened_floor).to eq '2. UG'
    end

    it 'formats on ground in short form' do
      @figure.model.update_attribute :floor, 0
      expect(@figure.shortened_floor).to eq 'EG'
    end

    it 'formats above ground in short form' do
      @figure.model.update_attribute :floor, 3
      expect(@figure.shortened_floor).to eq '3. OG'
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

  describe '#property_surface' do
    it 'formats the size' do
      @figure.property_surface.should == '145 m²'
    end

    it 'renders the estimate property surface if present' do
      @figure.update_attribute :property_surface_estimate, '182 - 120 m²'
      @figure.property_surface.should == '182 - 120 m²'
    end
  end

  describe '#usable_surface' do
    it 'formats the size' do
      @figure.usable_surface.should == '135 m²'
    end

    it 'renders the estimate usable surface if present' do
      @figure.update_attribute :usable_surface_estimate, '181 - 191 m²'
      @figure.usable_surface.should == '181 - 191 m²'
    end
  end

  it 'formats the size the storage surface' do
    @figure.storage_surface.should == '155 m²'
  end

  context 'for private usage' do
    before :each do
      @real_estate = Fabricate(:published_real_estate,
                               :category => Fabricate(:category),
                               :utilization => Utilization::LIVING,
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
                               :utilization => Utilization::WORKING,
                               :figure => Fabricate.build(:figure,
                                                          :living_surface => 153,
                                                          :usable_surface => 120
                                                         )
                              )

      @figure = FigureDecorator.new(@real_estate.figure)
    end

    describe '#surface' do
      it 'returns the formatted usable surface' do
        @figure.update_attribute :usable_surface_estimate, ''
        @figure.surface.should == '120 m²'
      end

      it 'returns the estimate usable surface' do
        @figure.update_attribute :usable_surface_estimate, '82 - 93 m²'
        @figure.surface.should == '82 - 93 m²'
      end
    end
  end
end
