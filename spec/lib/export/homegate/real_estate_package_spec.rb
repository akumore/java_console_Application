require 'spec_helper'

describe Export::Homegate::RealEstatePackage do
  before :each do
    @tmp_path = File.join Rails.root, 'tmp', 'specs'
    FileUtils.mkdir_p @tmp_path
    FileUtils.mkdir_p File.join(@tmp_path, 'data')
    FileUtils.mkdir_p File.join(@tmp_path, 'images')
    FileUtils.mkdir_p File.join(@tmp_path, 'movies')
    FileUtils.mkdir_p File.join(@tmp_path, 'documents')
  end

  after :each do
    #FileUtils.rm_rf(@tmp_path)
  end

  let :real_estate do
    Fabricate(:real_estate,
      :category => Fabricate(:category),
      :reference => Reference.new,
      :address => Fabricate.build(:address),
      :media_assets => [
        Fabricate.build(:media_asset_image),
        Fabricate.build(:media_asset_image),
        Fabricate.build(:media_asset_image_png),
        Fabricate.build(:media_asset_video),
        Fabricate.build(:media_asset_video),
        Fabricate.build(:media_asset_document),
        Fabricate.build(:media_asset_document)
      ]
    )
  end

  let :packager do
    packager = Export::Homegate::Packager.new
    packager.stub!(:path).and_return(@tmp_path)
    packager
  end

  describe '#save' do
    it 'packages all assets into their respective folders' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.should_receive(:package_assets).once
      package.save
    end

    it 'writes the unload.txt file' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.should_receive(:write).once
      package.save
    end
  end

  describe '#package_assets' do
    it 'copies the real estate images into /images' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.should_receive(:add_image).exactly(3).times
      package.package_assets
    end

    it 'copies the real estate videos into /movies' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.should_receive(:add_video).exactly(2).times
      package.package_assets
    end

    it 'copies the real estate videos into /documents' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.should_receive(:add_document).exactly(2).times
      package.package_assets
    end
  end

  describe '#write' do
    it 'creates the unload.txt file' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.write
      File.exists?(File.join(@tmp_path, 'data', 'unload.txt')).should be_true
    end
  end

  describe '#add_image' do
    context 'with a png image' do
      it 'converts the image to the jpeg format' do
        package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
        file = real_estate.media_assets.images.last.file
        file.should_receive(:jpeg_format)
        package.add_image(file)
      end
    end

    context 'with a jpeg image' do
      it 'does not convert the image to the jpeg format' do
        package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
        file = real_estate.media_assets.images.first.file
        file.should_not_receive(:jpeg_format)
        package.add_image(file)
      end
    end

    it 'remembers the filename for the export' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_image(real_estate.media_assets.images.first.file)
      package.asset_paths[:images].first.should == "i_#{real_estate.id}_1.jpg"
    end

    it 'copies the image into /images with a unique filename' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_image(real_estate.media_assets.images.first.file)
      File.exists?(File.join(@tmp_path, 'images', "i_#{real_estate.id}_1.jpg")).should be_true
    end
  end

  describe '#add_video' do
    it 'remembers the filename for the export' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_video(real_estate.media_assets.videos.first.file)
      package.asset_paths[:videos].first.should == "v_#{real_estate.id}_1.mp4"
    end

    it 'copies the video into /movies with a unique filename' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_video(real_estate.media_assets.videos.first.file)
      File.exists?(File.join(@tmp_path, 'movies', "v_#{real_estate.id}_1.mp4")).should be_true
    end
  end

  describe '#add_document' do
    it 'remembers the filename for the export' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_document(real_estate.media_assets.docs.first.file)
      package.asset_paths[:documents].first.should == "d_#{real_estate.id}_1.pdf"
    end

    it 'copies the documet into /documents with a unique filename' do
      package = Export::Homegate::RealEstatePackage.new(real_estate, packager)
      package.add_document(real_estate.media_assets.docs.first.file)
      File.exists?(File.join(@tmp_path, 'documents', "d_#{real_estate.id}_1.pdf")).should be_true
    end
  end
end