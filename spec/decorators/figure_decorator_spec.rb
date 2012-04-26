# encoding: utf-8
require 'spec_helper'

describe FigureDecorator do
  before { ApplicationController.new.set_current_view_context }

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
        @figure.surface.should == '153 m²'
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
