require 'spec_helper'

describe Export::Idx301::Packager do
  let :account do
    Account.new(:provider => 'test')
  end

  describe '.packager_class_for_account' do
    context 'when the account is immoscout' do
      it 'returns the immoscout packager' do
        Export::Idx301::Packager.packager_class_for_provider('immoscout24').should be(Export::Idx301::ImmoscoutPackager)
      end
    end

    context 'any other account' do
      it 'returns the default packager' do
        Export::Idx301::Packager.packager_class_for_provider('homegate').should be(Export::Idx301::Packager)
      end
    end
  end

  describe '#package' do
    before do
      create_tmp_export_dir!
    end

    after do
      remove_tmp_export_dir!
    end

    it 'returns if packaging a real estate was successful' do
      packager = Export::Idx301::Packager.new account
      packager.stub!(:path).and_return(File.join(Rails.root, 'tmp', 'specs'))
      real_estate = Fabricate.build :published_real_estate, :category=>Fabricate(:category)
      packager.package(real_estate).should be_true
    end
  end

  describe '#path' do
    it 'returns the path for storing an export' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new account
        packager.path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end

  describe '#data_path' do
    it 'returns the path for storing the unload.txt' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new account
        packager.data_path.should == "#{packager.root_path}/2012_05_20/16_35/test/data"
      end
    end
  end

  describe '#doc_path' do
    it 'returns the path for storing the documents' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new account
        packager.doc_path.should == "#{packager.root_path}/2012_05_20/16_35/test/doc"
      end
    end
  end

  describe '#image_path' do
    it 'returns the path for storing the images' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new account
        packager.image_path.should == "#{packager.root_path}/2012_05_20/16_35/test/images"
      end
    end
  end

  describe '#movie_path' do
    it 'returns the path for storing the movies' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new account
        packager.movie_path.should == "#{packager.root_path}/2012_05_20/16_35/test/movies"
      end
    end
  end

  describe '#root_path' do
    it 'returns the root path for all export folders' do
      packager = Export::Idx301::Packager.new account
      packager.root_path.should == "#{Rails.root}/tmp/export"
    end
  end
end
