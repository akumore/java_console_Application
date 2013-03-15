require 'spec_helper'

describe ReferenceProject do

  let :valid_reference_project do
    ReferenceProject.create(:title => 'title',
                            :description => 'description',
                            :construction_info => 'Construction Info',
                            :section => ReferenceProjectSection::RESIDENTIAL_BUILDING,
                            :attachment => File.open("#{Rails.root}/spec/support/test_files/document.pdf"),
                            :images => [Fabricate.build(:reference_project_image)]
                           )
  end

  let :invalid_reference_project do
    ReferenceProject.new
  end

  describe 'initialize without any attributes' do
    before :each do
      invalid_reference_project = ReferenceProject.new()
    end

    it 'does not pass validations' do
      invalid_reference_project.should_not be_valid
    end

    it 'requires a title' do
      invalid_reference_project.should have(1).error_on(:title)
    end

    it 'requires images' do
      invalid_reference_project.should have(1).error_on(:images)
    end

    it 'requires a section' do
      invalid_reference_project.should have(1).error_on(:section)
    end

    it 'has 3 errors' do
      invalid_reference_project.valid?
      invalid_reference_project.errors.should have(3).items
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
