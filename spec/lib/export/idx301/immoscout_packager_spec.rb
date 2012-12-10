require 'spec_helper'

describe Export::Idx301::ImmoscoutPackager do
  let :account do
    Account.new(:provider => 'test')
  end

  describe '#data_path' do
    it 'returns the path for storing the unload.txt' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::ImmoscoutPackager.new account
        packager.data_path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end

  describe '#doc_path' do
    it 'returns the path for storing the documents' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::ImmoscoutPackager.new account
        packager.doc_path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end

  describe '#image_path' do
    it 'returns the path for storing the images' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::ImmoscoutPackager.new account
        packager.image_path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end

  describe '#movie_path' do
    it 'returns the path for storing the movies' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::ImmoscoutPackager.new account
        packager.movie_path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end
end
