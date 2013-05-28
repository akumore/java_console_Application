require 'spec_helper'

describe ReferenceProject do

  let :valid_reference_project do
    Fabricate(:reference_project)
  end

  let :invalid_reference_project do
    ReferenceProject.new
  end

  describe 'initialize without any attributes' do
    it 'does not pass validations' do
      invalid_reference_project.should_not be_valid
    end

    it 'requires a title' do
      invalid_reference_project.should have(1).error_on(:title)
    end

    it 'requires images' do
      invalid_reference_project.should have(1).error_on(:images)
    end

    it 'has 2 errors' do
      invalid_reference_project.valid?
      invalid_reference_project.errors.should have(2).items
    end
  end

  describe 'initialize with preselected display on options' do
    context 'on home and offer page option' do
      before :each do
        invalid_reference_project.displayed_on = [ ReferenceProject::HOME_AND_OFFER_PAGE ]
        invalid_reference_project.save
      end

      it 'requires a title' do
        invalid_reference_project.should have(1).error_on(:title)
      end

      it 'requires images' do
        invalid_reference_project.should have(1).error_on(:images)
      end

      it 'has 2 errors' do
        invalid_reference_project.valid?
        invalid_reference_project.errors.should have(2).items
      end
    end

    context 'on reference projects page option' do
      before :each do
        invalid_reference_project.displayed_on = [ ReferenceProject::REFERENCE_PROJECT_PAGE ]
        invalid_reference_project.save
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

    context 'on both options checked' do
      before :each do
        invalid_reference_project.displayed_on = [ ReferenceProject::HOME_AND_OFFER_PAGE, ReferenceProject::REFERENCE_PROJECT_PAGE ]
        invalid_reference_project.save
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

  describe '#slider_image' do
    it 'should return first image from images array' do
      valid_reference_project.slider_image.should == valid_reference_project.images.first.image
    end
  end
end
