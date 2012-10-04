require 'spec_helper'

describe Export::Idx301::Packager do
  let :target do
    Export::Idx301::Target.new 'test', 'test', 'test', {}
  end

  describe '.packager_class_for_target' do
    context 'when the target is immoscout' do
      it 'returns the immoscout packager' do
        Export::Idx301::Packager.packager_class_for_target('immoscout24').should be(Export::Idx301::ImmoscoutPackager)
      end
    end

    context 'when the target is home.ch' do
      it 'returns the home_ch packager' do
        Export::Idx301::Packager.packager_class_for_target('home_ch').should be(Export::Idx301::HomeChPackager)
      end
    end

    context 'any other target' do
      it 'returns the default packager' do
        Export::Idx301::Packager.packager_class_for_target('homegate').should be(Export::Idx301::Packager)
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
      packager = Export::Idx301::Packager.new target
      packager.stub!(:path).and_return(File.join(Rails.root, 'tmp', 'specs'))
      real_estate = Fabricate.build :published_real_estate, :category=>Fabricate(:category)
      packager.package(real_estate).should be_true
    end
  end

  describe '#path' do
    it 'returns the path for storing an export' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new target
        packager.path.should == "#{packager.root_path}/2012_05_20/16_35/test"
      end
    end
  end

  describe '#data_path' do
    it 'returns the path for storing the unload.txt' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new target
        packager.data_path.should == "#{packager.root_path}/2012_05_20/16_35/test/data"
      end
    end
  end

  describe '#doc_path' do
    it 'returns the path for storing the documents' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new target
        packager.doc_path.should == "#{packager.root_path}/2012_05_20/16_35/test/doc"
      end
    end
  end

  describe '#image_path' do
    it 'returns the path for storing the images' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new target
        packager.image_path.should == "#{packager.root_path}/2012_05_20/16_35/test/images"
      end
    end
  end

  describe '#movie_path' do
    it 'returns the path for storing the movies' do
      time_travel_to(Time.new(2012, 5, 20, 16, 35)) do
        packager = Export::Idx301::Packager.new target
        packager.movie_path.should == "#{packager.root_path}/2012_05_20/16_35/test/movies"
      end
    end
  end

  describe '#root_path' do
    it 'returns the root path for all export folders' do
      packager = Export::Idx301::Packager.new target
      packager.root_path.should == "#{Rails.root}/tmp/export"
    end
  end
end
