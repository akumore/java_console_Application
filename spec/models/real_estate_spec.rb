require 'spec_helper'

describe RealEstate do
  describe 'initialize without any attributes' do
    before :each do
      @real_estate = RealEstate.new(:state => '', :utilization => '', :offer => '')
    end

    it 'does not pass validations' do
      @real_estate.should_not be_valid
    end

    it 'requires a category' do
      @real_estate.should have(1).error_on(:category_id)
    end

    it 'requires a state' do
      @real_estate.should have(1).error_on(:state)
    end

    it 'requires a utilization' do
      @real_estate.should have(1).error_on(:utilization)
    end

    it 'requires a offer' do
      @real_estate.should have(1).error_on(:offer)
    end

    it 'requires a title' do
      @real_estate.should have(1).error_on(:title)
    end

    it 'requires a description' do
      @real_estate.should have(1).error_on(:description)
    end

    it 'has 6 errors' do
      @real_estate.valid?
      @real_estate.errors.should have(6).items
    end
  end  

  describe '#row_house?' do
  	context 'with the category set to row_house' do
  		it 'is true' do
  			real_estate = Fabricate(:real_estate, :category => Fabricate(:category, :label => 'Reihenfamilienhaus', :name => 'row_house'))
  			real_estate.row_house?.should be_true
  		end
  	end

  	context 'with the category set to flat' do
  		it 'is false' do
  			real_estate = Fabricate(:real_estate, :category => Fabricate(:category, :label => 'Wohnung', :name => 'flat'))
  			real_estate.row_house?.should be_false
  		end
  	end
  end

  describe '#valid_for_publishing?' do
    it 'should return true' do
      Fabricate.build(:real_estate,
        :category => Fabricate(:category),
        :contact => Fabricate(:employee),
        :reference => Fabricate.build(:reference),
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :figure => Fabricate.build(:figure),
        :information => Fabricate.build(:information),
        :infrastructure => Fabricate.build(:infrastructure),
        :additional_description => Fabricate.build(:additional_description)
      ).valid_for_publishing?.should be_true
    end

    it 'should return false' do
      Fabricate.build(:real_estate).valid_for_publishing?.should be_false
    end
  end

  describe 'top_level_category' do
    before do
      @toplevel_category = Fabricate.build :category
      @second_level_category = Fabricate.build :category, :parent=>@toplevel_category
      @real_estate = Fabricate.build :real_estate
    end

    it "returns the parent category of it's category" do
      @real_estate.category = @second_level_category
      @real_estate.top_level_category.should == @toplevel_category
    end
  end

  it "returns real estates published as reference project only" do
    Fabricate :real_estate, :channels => [RealEstate::WEBSITE_CHANNEL], :category => Fabricate(:category)
    reference_project = Fabricate :real_estate, :channels => [RealEstate::REFERENCE_PROJECT_CHANNEL, RealEstate::WEBSITE_CHANNEL], :category => Fabricate(:category)
    RealEstate.reference_projects.all.should == [reference_project]
  end

  describe "State machine" do

    let :category do
      Fabricate :category
    end

    it "has default state 'editing'" do
      real_estate = RealEstate.new
      real_estate.editing?.should be_true
    end

    it "transitions from 'editing' to 'review'" do
      real_estate = Fabricate(:real_estate, :category => category)
      real_estate.stub!(:valid_for_publishing?).and_return(true)
      real_estate.review_it!

      real_estate.in_review?.should be_true
    end

    it "transitions from 'review' to 'published'" do
      real_estate = Fabricate(:real_estate, :state => 'in_review', :category => category)
      real_estate.stub!(:valid_for_publishing?).and_return(true)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'review' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'in_review', :category => category)
      real_estate.reject_it!
      real_estate.editing?.should be_true
    end

    it "transitions from 'editing' to 'published'" do
      real_estate = Fabricate(:real_estate, :state => 'editing', :category => category)
      real_estate.stub!(:valid_for_publishing?).and_return(true)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'published' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'published', :category => category)
      real_estate.unpublish_it!
      real_estate.editing?.should be_true
    end
  end

  describe '#invalid_submodels' do
    it 'returns the names of invalid submodels' do
      real_estate = Fabricate.build(:real_estate, 
        :state => 'editing',
        :category => Fabricate(:category),
        :address => Address.new,
        :pricing => Pricing.new
      )

      real_estate.invalid_submodels.should == %w(address pricing)
    end
  end
end
