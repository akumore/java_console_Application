require 'spec_helper'

describe GalleryPhoto do
  describe 'initialize without any attributes' do
    let :gallery_photo do
      GalleryPhoto.new
    end

    it 'does not pass validations' do
      gallery_photo.should_not be_valid
    end

    it 'requires a title' do
      gallery_photo.should have(1).error_on(:title)
    end

    it 'requires a image' do
      gallery_photo.should have(1).error_on(:image)
    end

    it 'has 2 errors' do
      gallery_photo.valid?
      gallery_photo.errors.should have(2).items
    end
  end
end
