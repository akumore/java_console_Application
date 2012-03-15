require 'spec_helper'

describe Export::Homegate::Packager do
  describe '#package' do
    it 'returns if packaging a real estate was successful' do
      packager = Export::Homegate::Packager.new
      packager.package(mock_model(RealEstate)).should be_true
    end
  end

  describe '#path' do
    it 'returns the path for storing an export' do
      packager = Export::Homegate::Packager.new

      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager.path.should == "#{packager.root_path}/2012_05_20/16_35"
      end
    end
  end

  describe '#root_path' do
    packager = Export::Homegate::Packager.new
    packager.root_path.should == "#{Rails.root}/tmp/export"
  end
end