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

    it 'requires an office' do
      @real_estate.should have(1).error_on(:office_id)
    end

    it 'has 7 errors' do
      @real_estate.valid?
      @real_estate.errors.should have(7).items
    end

    context 'when microsite is selected' do
      let :microsite_real_estate do
        RealEstate.new(:channels => [RealEstate::MICROSITE_CHANNEL])
      end

      it 'requires a selected microsite option' do
        microsite_real_estate.should have(2).error_on(:microsite_building_project)
      end
    end

    context 'when having a parking utilization' do
      before do
        @real_estate.stub(:utilization).and_return(Utilization::PARKING)
      end

      it 'doesnt require a description' do
        @real_estate.should_not have(1).error_on(:description)
      end

      it 'doesnt require a title' do
        @real_estate.should_not have(1).error_on(:description)
      end
    end
  end

  describe '#handout' do
    let :real_estate do
      RealEstate.new
    end

    context 'when has_handout? is true' do
      it 'returns a Handout object' do
        real_estate.stub!(:has_handout?).and_return(true)
        real_estate.handout.should be_a(Handout)
      end
    end

    context 'when has_handout? is false' do
      it 'returns a Handout object' do
        real_estate.stub!(:has_handout?).and_return(false)
        real_estate.handout.should be_a(Handout)
      end
    end
  end

  describe '#has_handout?' do

    context 'when for rent' do
      let :real_estate do
        RealEstate.new(
          :offer => Offer::RENT,
          :channels => [RealEstate::PRINT_CHANNEL]
        )
      end

      context 'when channel is active' do
        it 'returns a handout' do
          real_estate.has_handout?.should be_true
        end
      end

      context 'when channel is inactive' do
        it 'returns nil' do
          real_estate.channels = []
          real_estate.has_handout?.should be_false
        end
      end
    end

    context 'when for sale' do
      let :real_estate do
        RealEstate.new(
          :offer => Offer::SALE,
          :channels => [RealEstate::PRINT_CHANNEL]
        )
      end

      context 'when channel is active' do
        it 'returns nil' do
          real_estate.has_handout?.should be_false
        end
      end

      context 'when channel is inactive' do
        it 'returns nil' do
          real_estate.channels = []
          real_estate.has_handout?.should be_false
        end
      end
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

  describe '#for_work_or_storage?' do
    context 'when the utilization is commercial' do
      it 'returns true' do
        real_estate = RealEstate.new(:utilization => Utilization::WORKING)
        real_estate.for_work_or_storage?.should be_true
      end
    end

    context 'when the utilization is storage' do
      it 'returns true' do
        pending 'add check for storage type'
        #real_estate = RealEstate.new(:utilization => Utilization::STORING)
        real_estate.for_work_or_storage?.should be_true
      end
    end

    context 'when the utilization is private' do
      it 'returns false' do
        real_estate = RealEstate.new(:utilization => Utilization::LIVING)
        real_estate.for_work_or_storage?.should be_false
      end
    end
  end

  describe '#copy' do
    before do
      @original = Fabricate :published_real_estate, :category => Fabricate(:category), :pricing => Fabricate.build(:pricing),
                            :address => Fabricate.build(:address), :information => Fabricate.build(:information)
    end

    let :copy do
      RealEstate.copy!(@original)
    end

    it 'should be valid' do
      copy.valid?.should be_true
    end

    it 'is also an real estate' do
      copy.should be_a RealEstate
    end

    it 'has an new, unique id' do
      copy.id.should_not == @original.id
    end

    it 'changes the title to reflect being a copy' do
      copy.title.should == "Kopie von #{@original.title}"
    end

    it 'changes the state to in editing' do
      copy.state.should == RealEstate::STATE_EDITING
    end

    it 'saves the copy' do
      copy.persisted?.should be_true
    end

    describe 'Copying assets' do
      let(:image) { Fabricate.build :media_assets_image }
      let(:image_copy) { copy.images.first }

      it 'makes a copy of the images' do
        @original.images << image
        image_copy.title.should == image.title
        File.basename(image_copy.file.to_s).should == File.basename(image.file.to_s)
      end

      it 'creates images from scratch with a global-unique id' do
        #this is important in order to keep the storage path of the carrierwave uploader unique
        @original.images << Fabricate.build(:media_assets_image)
        copy.images.count.should == @original.images.count
        image_copy.id.should_not == @original.images.first.id
        image_copy.file.to_s.should_not == @original.images.first.file.to_s
      end

      let(:floor_plan) { Fabricate.build :media_assets_floor_plan }
      let(:floor_plan_copy) { copy.floor_plans.first }

      it 'makes a copy of the floor_plans' do
        @original.floor_plans << floor_plan
        floor_plan_copy.title.should == floor_plan.title
        File.basename(floor_plan_copy.file.to_s).should == File.basename(floor_plan.file.to_s)
      end

      it 'creates floor plans from scratch with a global-unique id' do
        #this is important in order to keep the storage path of the carrierwave uploader unique
        @original.floor_plans << Fabricate.build(:media_assets_floor_plan)
        copy.floor_plans.count.should == @original.floor_plans.count
        copy.floor_plans.first.id.should_not == @original.floor_plans.first.id
        copy.floor_plans.first.file.to_s.should_not == @original.floor_plans.first.file.to_s
      end

      let(:video) { Fabricate.build :media_assets_video }
      let(:video_copy) { copy.videos.first }

      it 'makes a copy of the videos' do
        @original.videos << video
        video_copy.title.should == video.title
        File.basename(video_copy.file.to_s).should == File.basename(video.file.to_s)
      end

      it 'creates videos from scratch with a global-unique id' do
        #this is important in order to keep the storage path of the carrierwave uploader unique
        @original.videos << video
        copy.videos.count.should == @original.videos.count
        video_copy.id.should_not == @original.videos.first.id
        video_copy.file.to_s.should_not == @original.videos.first.file.to_s
      end

      let(:document) { Fabricate.build :media_assets_document }
      let(:document_copy) { copy.documents.first}

      it 'makes a copy of the documents' do
        @original.documents << document
        document_copy.title.should == document.title
        File.basename(document_copy.file.to_s).should == File.basename(document.file.to_s)
      end

      it 'creates documents from scratch with a global-unique id' do
        #this is important in order to keep the storage path of the carrierwave uploader unique
        @original.documents << document
        copy.documents.count.should == @original.documents.count
        document_copy.id.should_not == document.id
        document_copy.file.to_s.should_not == document.file.to_s
      end
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


  describe 'Publishing-channel scopes' do
    before do
      category = Fabricate(:category)
      @website_enabled = Fabricate :real_estate, :channels => [RealEstate::WEBSITE_CHANNEL], :category => category
      @homegate_enabled = Fabricate :real_estate, :channels => [RealEstate::EXTERNAL_REAL_ESTATE_PORTAL_CHANNEL, RealEstate::WEBSITE_CHANNEL], :category => category
      @print_enabled = Fabricate :real_estate, :channels => [RealEstate::PRINT_CHANNEL, RealEstate::WEBSITE_CHANNEL], :category => category
      @microsite_enabled = Fabricate :real_estate, :channels => [RealEstate::MICROSITE_CHANNEL], :category => category, :microsite_building_project => MicrositeBuildingProject::GARTENSTADT
    end

    it "gets real estates for website" do
      [@website_enabled, @homegate_enabled, @print_enabled].each do |real_estate|
        RealEstate.web_channel.all.should include real_estate
      end
    end

    it "gets real estates for print" do
      RealEstate.print_channel.all.should == [@print_enabled]
    end

    it "gets real estates for microsite" do
      RealEstate.microsite.all.should == [@microsite_enabled]
    end

  end

  describe 'default_order scope' do
    it 'orders by city by default' do
      ('a'..'c').each do |x|
        real_estate = Fabricate :residential_building,
          :address => Fabricate.build(:address, city: x)
      end

      RealEstate.default_order.first.address.city.should eq 'a'
      RealEstate.default_order.last.address.city.should eq 'c'
    end

    it 'orders by street when the cities are the same' do
      ('a'..'c').each do |x|
        real_estate = Fabricate :residential_building,
          :address => Fabricate.build(:address, city: 'Zug', street: x)
      end

      RealEstate.default_order.first.address.street.should eq 'a'
      RealEstate.default_order.last.address.street.should eq 'c'
    end

    it 'orders by street number when the cities and the streets are the same' do
      (1..3).each do |x|
        real_estate = Fabricate :residential_building,
          :address => Fabricate.build(:address, city: 'Zug', street: 'Sennweidstrasse', street_number: x)
      end

      RealEstate.default_order.first.address.street_number.should eq '1'
      RealEstate.default_order.last.address.street_number.should eq '3'
    end
  end

  it 'detects embedded models having a presence validation defined' do
    RealEstate.mandatory_for_publishing.should == ["address", "pricing", "figure", "information"]
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
        :information => Fabricate.build(:information),
        :figure => Fabricate.build(:figure),
        :creator => Fabricate(:cms_editor),
        :editor => Fabricate(:cms_editor)
      real_estate.review_it!

      real_estate.in_review?.should be_true
    end

    it "transitions from 'review' to 'published'" do
      real_estate = Fabricate :real_estate, :state => 'in_review',
        :category => category,
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information),
        :figure => Fabricate.build(:figure),
        :creator => Fabricate(:cms_editor),
        :editor => Fabricate(:cms_editor)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'review' to 'editing'" do
      real_estate = Fabricate :real_estate,
                              :state => 'in_review',
                              :category => category,
                              :creator => Fabricate(:cms_editor),
                              :editor => Fabricate(:cms_editor)

      real_estate.reject_it!
      real_estate.editing?.should be_true
    end

    it "transitions from 'editing' to 'published'" do
      real_estate = Fabricate :real_estate,
        :state => 'editing',
        :category => category,
        :address => Fabricate.build(:address),
        :pricing => Fabricate.build(:pricing),
        :information => Fabricate.build(:information),
        :figure => Fabricate.build(:figure)
      real_estate.publish_it!

      real_estate.published?.should be_true
    end

    it "transitions from 'published' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'published', :category => category)
      real_estate.unpublish_it!
      real_estate.editing?.should be_true
    end

    it "transitions from 'editing' to 'archived'" do
      real_estate = Fabricate(:real_estate, :state => 'editing', :category => category)
      real_estate.archive_it!
      real_estate.archived?.should be_true
    end

    it "transitions from 'published' to 'archived'" do
      real_estate = Fabricate(:real_estate, :state => 'published', :category => category)
      real_estate.archive_it!
      real_estate.archived?.should be_true
    end

    it "transitions from 'archived' to 'editing'" do
      real_estate = Fabricate(:real_estate, :state => 'archived', :category => category)
      real_estate.reactivate_it!
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
        r = Fabricate(:real_estate, :category => Fabricate(:category), :creator => Fabricate(:cms_editor), :editor => Fabricate(:cms_editor))
        r.update_attribute :state, 'in_review'
        r.update_attributes(:title => "Something is changed").should be_true
      end

      it "can't be saved in state 'published' anyway" do
        r = Fabricate(:published_real_estate, :category=>Fabricate(:category))
        r.update_attributes(:title => "Something is changed").should be_false
      end

      it "can change over from 'in_review' to 'editing'" do
        r = Fabricate :real_estate,
                      :state=>'in_review',
                      :category=>Fabricate(:category),
                      :creator => Fabricate(:cms_editor),
                      :editor => Fabricate(:cms_editor)
        r.reject_it.should be_true
      end
    end

    context "Sub-model becomes invalid because of real estate changed" do #e.g. changing the offer type will cause an invalid pricing model
      # e.g. changing the offer type will cause an invalid pricing model
      before do
        @real_estate = Fabricate :real_estate, :offer => Offer::RENT,
                                  :category => Fabricate(:category),
                                  :address => Fabricate.build(:address),
                                  :pricing => Fabricate.build(:pricing, :for_sale=>nil),
                                  :information => Fabricate.build(:information),
                                  :figure => Fabricate.build(:figure)
      end

      it "doesn't change over from 'editing' to 'in_review'" do
        @real_estate.update_attribute :offer, Offer::SALE

        @real_estate.review_it.should be_false
        @real_estate.errors.should include :pricing
      end

      it "doesn't change over from 'editing' to 'published'" do
        @real_estate.update_attribute :offer, Offer::SALE

        @real_estate.publish_it.should be_false
        @real_estate.errors.should include :pricing
      end

      it "doesn't change over from 'in_review' to 'published'" do
        @real_estate.creator = Fabricate(:cms_editor)
        @real_estate.editor = Fabricate(:cms_editor)
        @real_estate.review_it.should be_true
        @real_estate.update_attribute :offer, Offer::SALE

        @real_estate.publish_it.should be_false
      end
    end
  end

  describe '#to_model_access' do
    it 'returns a model access instance' do
      real_estate = RealEstate.new(:offer => Offer::SALE, :utilization => Utilization::LIVING)
      real_estate.to_model_access.should be_a(ModelAccess)
    end
  end

  describe '#validate_figure_in_editing_state?' do
    let :real_estate do
      RealEstate.new.tap do |r|
        r.stub(:parking).and_return(false)
        r.stub(:state_changed?).and_return(true)
      end
    end

    it 'returns true' do
      real_estate.validate_figure_in_editing_state?.should be_true
    end

    context 'when having the parking utilization' do
      it 'returns false' do
        real_estate.stub(:parking?).and_return(true)
        real_estate.validate_figure_in_editing_state?.should be_false
      end
    end
  end

  describe '#validate_figure_in_published_state?' do
    let :real_estate do
      RealEstate.new.tap do |r|
        r.stub(:parking).and_return(false)
      end
    end

    it 'returns true' do
      real_estate.validate_figure_in_published_state?.should be_true
    end

    context 'when having the parking utilization' do
      it 'returns false' do
        real_estate.stub(:parking?).and_return(true)
        real_estate.validate_figure_in_published_state?.should be_false
      end
    end
  end

  describe '#any_descriptions?' do
    let :real_estate do
      RealEstate.new(:description => 'stuff',
                     :additional_description => AdditionalDescription.new(:location => 'Location description',
                                                                           :interior => 'Interior description')
                    )
    end

    context 'when description is given' do
      it 'returns true' do
        real_estate.any_descriptions?.should be_true
      end
    end

    context 'when additional descriptions are given' do
      it 'returns true' do
        real_estate.any_descriptions?.should be_true
      end

      context 'when no main description is given' do
        it 'returns true' do
          real_estate.stub(:description).and_return('')
          real_estate.any_descriptions?.should be_true
        end
      end

      context 'when parking without main description' do
        it 'returns false' do
          real_estate.stub(:description).and_return('')
          real_estate.stub(:parking?).and_return(true)
          real_estate.any_descriptions?.should be_false
        end
      end
    end

    context 'when parking' do
      before do
        real_estate.stub(:parking?).and_return(true)
      end

      context 'when having a description' do
        it 'returns true' do
          real_estate.any_descriptions?.should be_true
        end
      end

      context 'when having no description' do
        it 'returns false' do
          real_estate.stub(:description).and_return('')
          real_estate.any_descriptions?.should be_false
        end
      end
    end
  end

  describe '#is_microsite?' do
    context 'with microsite channel enabled' do
      let :real_estate do
        RealEstate.new(:channels => [RealEstate::MICROSITE_CHANNEL])
      end

      it 'returns true' do
        real_estate.is_microsite?.should be_true
      end
    end

    context 'with microsite channel disabled' do
      let :real_estate do
        RealEstate.new
      end

      it 'returns false' do
        real_estate.is_microsite?.should be_false
      end
    end
  end
end
