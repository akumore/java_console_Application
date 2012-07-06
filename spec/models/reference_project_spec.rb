require 'spec_helper'

describe ReferenceProject do

  let :valid_reference_project do
    ReferenceProject.create(:title => 'title', :description => 'description', :image => File.open("#{Rails.root}/spec/support/test_files/image.jpg"))
  end

  describe 'initialize without any attributes' do
    before :each do
      @reference_project = ReferenceProject.new()
    end

    it 'does not pass validations' do
      @reference_project.should_not be_valid
    end

    it 'requires a title' do
      @reference_project.should have(1).error_on(:title)
    end

    it 'requires a image' do
      @reference_project.should have(1).error_on(:image)
    end

    it 'has 2 errors' do
      @reference_project.valid?
      @reference_project.errors.should have(2).items
    end
  end

  describe 'initialize with valid attributes' do
    it 'initializes a valid reference project' do
      valid_reference_project.should be_valid
    end
  end

  describe 'position' do
    it 'initializes a valid reference project' do
      valid_reference_project.position.should == ReferenceProject.count
    end
  end

  describe 'real_estate' do
    it 'sets real_estate reference to nil when real_estate is dropped' do
      real_estate = Fabricate :residential_building
      valid_reference_project.real_estate = real_estate
      valid_reference_project.save!
      real_estate.destroy
      valid_reference_project.real_estate.should be_nil
    end
  end
end
