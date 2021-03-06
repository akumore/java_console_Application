require 'spec_helper'

describe Export::Idx301::RealEstatePackage do
  before :each do
    create_tmp_export_dir!
  end

  after :each do
    remove_tmp_export_dir!
  end

  let :real_estate do
    Fabricate(:real_estate,
      :category => Fabricate(:category),
      :reference => Reference.new,
      :address => Fabricate.build(:address),
      :images => 2.times.map { Fabricate.build :media_assets_image },
      :floor_plans => [Fabricate.build(:media_assets_floor_plan)],
      :videos => 2.times.map { Fabricate.build :media_assets_video },
      :documents => 2.times.map { Fabricate.build :media_assets_document }
    )
  end

  let :account do
    Account.new(:provider => 'test', :video_support => true)
  end

  let :packager do
    packager = Export::Idx301::Packager.new(account)
    packager.stub!(:path).and_return(@tmp_path)
    packager
  end

  let :unload_file do
    File.join Rails.root, 'tmp', 'unload.txt'
  end

  describe '#save' do
    before { MediaAssetUploader.enable_processing=true }
    after { MediaAssetUploader.enable_processing=false }

    it 'packages all assets into their respective folders' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.should_receive(:package_assets).once
      package.save unload_file
    end

    it 'writes the unload.txt file for the specified portal' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.save unload_file
      File.exists?(unload_file).should be_true
    end
  end

  describe '#package_assets' do
    before { MediaAssetUploader.enable_processing=true }
    after { MediaAssetUploader.enable_processing=false }

    it 'hardlinks the real estate images into /images' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.should_receive(:add_image).exactly(3).times
      package.package_assets
    end

    context 'with video support' do
      it 'hardlinks the real estate videos into /movies' do
        package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
        package.should_receive(:add_video).exactly(2).times
        package.package_assets
      end
    end

    context 'without video support' do
      it 'hardlinks the real estate videos into /movies' do
        account.stub!(:video_support?).and_return(false)
        package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
        package.should_not_receive(:add_video)
        package.package_assets
      end
    end

    it 'hardlinks the real estate videos into /documents' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.should_receive(:add_document).exactly(2).times
      package.package_assets
    end

    context 'when the object documentation channel is enabled' do

      before do
        real_estate.channels = [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL, RealEstate::PRINT_CHANNEL]
      end

      it 'adds the objects documentation' do
        package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
        package.should_receive(:add_handout).exactly(1).times
        package.package_assets
      end
    end
  end

  describe '#add_image' do
    it 'remembers the filename for the export' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_image(real_estate.images.first.file)
      package.asset_information[:images].first.should == "i_#{real_estate.id}_1.jpg"
    end

    it 'hardlinks the image into /images with a unique filename' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_image(real_estate.images.first.file)
      File.exists?(File.join(@tmp_path, 'images', "i_#{real_estate.id}_1.jpg")).should be_true
    end
  end

  describe '#add_image_title' do
    it 'remembers the image title for the export' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_image_title(real_estate.images.first.title)
      package.asset_information[:image_titles].first.should == real_estate.images.first.title
    end
  end

  describe '#add_video' do
    it 'remembers the filename for the export' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_video(real_estate.videos.first.file)
      package.asset_information[:videos].first.should == "v_#{real_estate.id}_1.mp4"
    end

    it 'hardlinks the video into /movies with a unique filename' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_video(real_estate.videos.first.file)
      File.exists?(File.join(@tmp_path, 'movies', "v_#{real_estate.id}_1.mp4")).should be_true
    end
  end

  describe '#add_document' do
    it 'remembers the filename for the export' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_document(real_estate.documents.first.file)
      package.asset_information[:documents].first.should == "d_#{real_estate.id}_1.pdf"
    end

    it 'hardlinks the document into /docs with a unique filename' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      package.add_document(real_estate.documents.first.file)
      File.exists?(File.join(@tmp_path, 'doc', "d_#{real_estate.id}_1.pdf")).should be_true
    end
  end

  describe '#add_handout' do
    it 'remembers the filename for the export' do
      package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
      real_estate.handout.should_receive(:to_file)
      package.add_handout(real_estate.handout)
      package.asset_information[:documents].first.should == "d_#{real_estate.id}_1.pdf"
    end

    context 'when a cache file is present' do
      it 'hardlinks the cache file' do
        pdf = File.join(Rails.root, 'public', real_estate.handout.path)
        package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
        File.stub!(:exists?).and_return(true)
        FileUtils.should_receive(:ln).with(pdf, File.join(@tmp_path, 'doc', "d_#{real_estate.id}_1.pdf"))
        real_estate.handout.should_not_receive(:to_file)
        package.add_handout(real_estate.handout)
      end
    end

    context 'when no cache file is present' do
      it 'creates the pdf in the export folder' do
        package = Export::Idx301::RealEstatePackage.new(real_estate, packager, account)
        real_estate.handout.should_receive(:to_file).with(File.join(@tmp_path, 'doc', "d_#{real_estate.id}_1.pdf"))
        package.add_handout(real_estate.handout)
      end
    end
  end
end
