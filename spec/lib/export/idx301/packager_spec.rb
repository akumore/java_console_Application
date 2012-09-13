require 'spec_helper'

describe Export::Idx301::Packager do
  describe '#package' do
    before do
      create_tmp_export_dir!
    end

    after do
      remove_tmp_export_dir!
    end

    it 'returns if packaging a real estate was successful' do
      packager = Export::Idx301::Packager.new
      packager.stub!(:path).and_return(File.join(Rails.root, 'tmp', 'specs'))
      real_estate = Fabricate.build :published_real_estate, :category=>Fabricate(:category)
      packager.package(real_estate).should be_true
    end
  end

  describe '#path' do
    it 'returns the path for storing an export' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new
        packager.path.should == "#{packager.root_path}/2012_05_20/16_35"
      end
    end
  end

  describe '#root_path' do
    it 'returns the root path for all export folders' do
      packager = Export::Idx301::Packager.new
      packager.root_path.should == "#{Rails.root}/tmp/export"
    end
  end
end
