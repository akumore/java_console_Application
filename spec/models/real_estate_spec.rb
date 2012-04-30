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

  describe '#category_label' do
    it 'contains the label of the referenced category' do
      category = Fabricate(:category)
      real_estate = Fabricate(:published_real_estate,
        :category => category,
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information),
        :address => Fabricate.build(:address)
      )

      real_estate.category_label.should == category.label
    end
  end
  
  describe '#copy' do
    before do
      @original = Fabricate(:published_real_estate,
        :category => Fabricate(:category),
        :pricing => Fabricate.build(:pricing),
        :address => Fabricate.build(:address),
        :information => Fabricate.build(:information)
      )
    end

    it 'copies the real estate with a new unique id' do
      copy = @original.copy
      copy.id.should_not == @original.id
      copy.should be_a(RealEstate)
    end

    it 'changes the title to reflect on the real estate beeing a copy' do
      @original.copy.title.should == "Kopie von #{@original.title}"
    end

    it 'changes the state to in editing' do
      @original.copy.state.should == RealEstate::STATE_EDITING
    end

    it 'saves the copy' do
      @original.copy.persisted?.should be_true
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

  it 'detects embedded models having a presence validation defined' do
    RealEstate.mandatory_for_publishing.should == ["address", "pricing", "information"]
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
      real_estate = Fabricate :real_estate,
        :category => category,
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information)
      real_estate.review_it!

      real_estate.in_review?.should be_true
    end

    it "transitions from 'review' to 'published'" do
      real_estate = Fabricate :real_estate, :state => 'in_review',
        :category => category,
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'review' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'in_review', :category => category)
      real_estate.reject_it!
      real_estate.editing?.should be_true
    end

    it "transitions from 'editing' to 'published'" do
      real_estate = Fabricate :real_estate,
        :state => 'editing',
        :category => category,
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'published' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'published', :category => category)
      real_estate.unpublish_it!
      real_estate.editing?.should be_true
    end

    context "Mandatory sub-model is missing" do
      before do
        @real_estate = Fabricate(:real_estate, :category=>Fabricate(:category))
        @mandatory_embedded_models = [:address, :pricing, :information]
      end

      it "doesn't change over from 'editing' to 'in_review'" do
        @real_estate.review_it.should be_false
        @mandatory_embedded_models.each { |model| @real_estate.errors.should include model }
      end

      it "doesn't change over from 'editing' to 'published'" do
        @real_estate.publish_it.should be_false
        @mandatory_embedded_models.each { |model| @real_estate.errors.should include model }
      end

      it "can be saved in state 'in_review' anyway" do
        r = Fabricate(:real_estate, :category=>Fabricate(:category))
        r.update_attribute :state, 'in_review'
        r.update_attributes(:title => "Something is changed").should be_true
      end

      it "can't be saved in state 'published' anyway" do
        r = Fabricate(:published_real_estate, :category=>Fabricate(:category))
        r.update_attributes(:title => "Something is changed").should be_false
      end

      it "can change over from 'in_review' to 'editing'" do
        r = Fabricate(:real_estate, :state=>'in_review', :category=>Fabricate(:category))
        r.reject_it.should be_true
      end
    end

    context "Sub-model becomes invalid because of real estate changed" do #e.g. changing the offer type will cause an invalid pricing model
      # e.g. changing the offer type will cause an invalid pricing model
      before do
        @real_estate = Fabricate :real_estate, :offer => RealEstate::OFFER_FOR_RENT,
                                  :category => Fabricate(:category),
                                  :address => Fabricate.build(:address),
                                  :pricing => Fabricate.build(:pricing, :for_sale=>nil),
                                  :information => Fabricate.build(:information)
      end

      it "doesn't change over from 'editing' to 'in_review'" do
        @real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE

        @real_estate.review_it.should be_false
        @real_estate.errors.should include :pricing
      end

      it "doesn't change over from 'editing' to 'published'" do
        @real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE

        @real_estate.publish_it.should be_false
        @real_estate.errors.should include :pricing
      end

      it "doesn't change over from 'in_review' to 'published'" do
        @real_estate.review_it.should be_true
        @real_estate.update_attribute :offer, RealEstate::OFFER_FOR_SALE

        @real_estate.publish_it.should be_false
      end
    end
  end

end
