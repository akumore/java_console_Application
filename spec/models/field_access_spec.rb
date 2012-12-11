require 'spec_helper'

describe FieldAccess do

  describe '#initialize' do
    let :field_access do
      FieldAccess.new(Offer::RENT, Utilization::LIVING)
    end

    it 'assigns the offer' do
      field_access.offer.should == 'rent'
    end

    it 'assigns the utilization' do
      field_access.utilization.should == 'living'
    end
  end

  describe '#key_for' do
    let :model do
      dummy = {}
      dummy.stub!(:model_name).and_return('figure')
      dummy
    end

    it 'returns a key' do
      field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING)
      field_access.key_for(model, :floor).should == 'rent.living.figure.floor'
    end
  end

  describe '#accessible?' do
    let :blacklist do
      %w(rent.living.figure.floor)
    end

    let :model do
      dummy = {}
      dummy.stub!(:model_name).and_return('figure')
      dummy
    end

    context 'when the given combination is blacklisted' do
      it 'returns false' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING, blacklist)
        field_access.accessible?(model, :floor).should be_false
      end
    end

    context 'when the given combination is not blacklisted' do
      it 'returns true' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::WORKING, blacklist)
        field_access.accessible?(model, :floor_estimate).should be_true
      end
    end
  end
end
