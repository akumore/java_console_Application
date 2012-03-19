require 'spec_helper'

describe Export::Homegate::Exporter do
  describe '#initialize' do
    it 'registers itself as observer' do
      dispatcher = Export::Dispatcher.new
      dispatcher.should_receive(:add_observer)
      Export::Homegate::Exporter.new(dispatcher)
    end
  end

  describe '#add' do
    let :exporter do
      Export::Homegate::Exporter.new(Export::Dispatcher.new)
    end

    context 'with a real estate suitable for the homegate export' do
      it 'is packaging the real estate' do
        real_estate = mock_model(RealEstate)
        real_estate.stub(:channels).and_return([RealEstate::HOMEGATE_CHANNEL])
        exporter.packager.should_receive(:package).with(real_estate)
        exporter.add(real_estate)
      end
    end

    context 'with a real estate not suitable for the homegate export' do
      it 'is not packaging the real estate' do
        real_estate = mock_model(RealEstate)
        real_estate.stub(:channels).and_return([RealEstate::WEBSITE_CHANNEL])
        exporter.packager.should_not_receive(:package).with(real_estate)
        exporter.add(real_estate)
      end
    end
  end

end