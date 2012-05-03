require 'spec_helper'

describe Export::Dispatcher do
  describe '#run' do
    before :each do
      @dispatcher = Export::Dispatcher.new
      @dispatcher.stub!(:exportable_real_estates).and_return([
        mock_model(RealEstate),
        mock_model(RealEstate),
        mock_model(RealEstate)
      ])
    end

    it 'notifies its observing exporters of real estates to be published' do
      pending 'fixed in development branch'
      @dispatcher.should_receive(:notify_observers).with(:add, kind_of(RealEstate)).exactly(3).times
      @dispatcher.run
    end
  end
end
