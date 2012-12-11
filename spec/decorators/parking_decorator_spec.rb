require 'spec_helper'

describe Rent::ParkingDecorator do
  # workaround for issue: https://github.com/jcasimir/draper/issues/60
  include Rails.application.routes.url_helpers
  before :all do
    c = ApplicationController.new
    c.request = ActionDispatch::TestRequest.new
    c.set_current_view_context
  end
  # end of workaround

  describe 'initialization of a decorator' do
    let :parking_real_estate do
      Fabricate(:commercial_building, :utilization => RealEstate::UTILIZATION_PARKING )
    end

    describe 'with single real estate' do
      let :decorator do
        RealEstateDecorator.decorate(parking_real_estate)
      end

      it 'initializes a new decorator instance' do
        decorator.should be_an_instance_of(RealEstateDecorator)
      end

      it 'responds to parking decorator methods' do
        decorator.should be_kind_of(Rent::ParkingDecorator)
      end

      it 'responds to real estate decorator methods' do
        decorator.should be_kind_of(Rent::ParkingDecorator)
      end
    end

    describe 'with homogenous real estates list' do
      let :decorator do
        RealEstateDecorator.decorate([parking_real_estate, parking_real_estate])
      end

      it 'extends decorator of every instance' do
        decorator[0].should be_kind_of(Rent::ParkingDecorator)
        decorator[1].should be_kind_of(Rent::ParkingDecorator)
      end
    end

    describe 'with heterogenous real estates list' do
      let :working_real_estate do
        Fabricate(:commercial_building)
      end

      let :decorator do
        RealEstateDecorator.decorate([parking_real_estate, working_real_estate])
      end

      it 'extends decorator only for parking' do
        decorator[0].should be_kind_of(Rent::ParkingDecorator)
        decorator[1].should_not be_kind_of(Rent::ParkingDecorator)
        decorator[1].should be_kind_of(Rent::WorkingDecorator)
      end
    end
  end
end
