require 'spec_helper'

describe FieldAccess do

  let :model do
    dummy = {}
    dummy.stub_chain(:class, :name).and_return('figure')
    dummy
  end

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
    it 'returns a key' do
      field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING)
      field_access.key_for(model, :floor).should == 'rent.living.figure.floor'
    end
  end

  describe '#any_offer_key_for' do
    it 'returns a key with an offer placeholder' do
      field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING)
      field_access.any_offer_key_for(model, :floor).should == '*.living.figure.floor'
    end
  end

  describe '#any_utilization_key_for' do
    it 'returns a key with a utilization placeholder' do
      field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING)
      field_access.any_utilization_key_for(model, :floor).should == 'rent.*.figure.floor'
    end
  end

  describe '#accessible?' do
    context 'when the given combination is blacklisted' do
      let :blacklist do
        %w(rent.living.figure.floor)
      end

      it 'returns false' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING, blacklist)
        field_access.accessible?(model, :floor).should be_false
      end
    end

    context 'when the given combination is not blacklisted' do
      let :blacklist do
        %w(rent.working.figure.floor)
      end

      it 'returns true' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING, blacklist)
        field_access.accessible?(model, :floor_estimate).should be_true
      end
    end

    context 'when the given combination is blacklisted with an offer placeholder' do
      let :blacklist do
        %w(*.living.figure.floor)
      end

      it 'returns false' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING, blacklist)
        field_access.accessible?(model, :floor).should be_false
      end
    end

    context 'when the given combination is blacklisted with a utilization placeholder' do
      let :blacklist do
        %w(rent.*.figure.floor)
      end

      it 'returns false' do
        field_access = FieldAccess.new(Offer::RENT, Utilization::LIVING, blacklist)
        field_access.accessible?(model, :floor).should be_false
      end
    end
  end
end
