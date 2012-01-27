require 'spec_helper'

describe MediaAsset do

  before :each do
    @real_estate = Fabricate(:real_estate,
      :category => Category.last,
      :reference => Reference.new
    )
  end
  
  describe 'initialize without any attributes' do
    before :each do
      @media_asset = MediaAsset.new
    end

    it 'does not pass validations' do
      @media_asset.should_not be_valid
    end

    it 'has 2 errors' do
      @media_asset.valid?
      @media_asset.errors.should have(2).items
    end
  end

  context 'image' do
    describe 'initialize image with valid attributes' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_image, :real_estate => @real_estate)
      end

      it 'passes validations' do
        @media_asset.should be_valid
      end
    end

    describe 'initialize with invalid image file' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_image,
         :real_estate => @real_estate,
         :file => File.open("#{Rails.root}/spec/support/test_files/video.mp4")
        )
      end

      it 'fails validations' do
        @media_asset.should_not be_valid
      end
    end 
  end

  context 'video' do
    describe 'initialize video with valid attributes' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_video, :real_estate => @real_estate)
      end

      it 'passes validations' do
        @media_asset.should be_valid
      end
    end

    describe 'initialize with invalid video file' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_video,
         :real_estate => @real_estate,
         :file => File.open("#{Rails.root}/spec/support/test_files/image.jpg")
        )
      end

      it 'fails validations' do
        @media_asset.should_not be_valid
      end
    end 
  end

  context 'document' do
    describe 'initialize video with valid attributes' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_document, :real_estate => @real_estate)
      end

      it 'passes validations' do
        @media_asset.should be_valid
      end
    end

    describe 'initialize with invalid document file' do
      before :each do
        @media_asset = Fabricate.build(:media_asset_document,
         :real_estate => @real_estate,
         :file => File.open("#{Rails.root}/spec/support/test_files/video.mp4")
        )
      end

      it 'fails validations' do
        @media_asset.should_not be_valid
      end
    end 
  end
end
