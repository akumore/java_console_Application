require 'spec_helper'

describe Export::Idx301::Exporter do

  let :portal do
    'my_portal'
  end

  describe '#initialize' do
    it 'registers itself as observer' do
      dispatcher = Export::Dispatcher.new
      dispatcher.should_receive(:add_observer)
      Export::Idx301::Exporter.new(dispatcher, portal)
    end
  end

  describe '#add' do
    let :exporter do
      Export::Idx301::Exporter.new(Export::Dispatcher.new, portal)
    end

    context 'with a real estate suitable for the an export to an external real estate portal' do
      it 'is packaging the real estate' do
        real_estate = mock_model(RealEstate)
        real_estate.stub(:channels).and_return([RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL])
        exporter.packager.should_receive(:package).with(real_estate)
        exporter.add(real_estate)
      end
    end

    context 'with a real estate not suitable for export to an external real estate portal' do
      it 'is not packaging the real estate' do
        real_estate = mock_model(RealEstate)
        real_estate.stub(:channels).and_return([RealEstate::WEBSITE_CHANNEL])
        exporter.packager.should_not_receive(:package).with(real_estate)
        exporter.add(real_estate)
      end
    end
  end

end
