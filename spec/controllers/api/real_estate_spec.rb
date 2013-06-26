# encoding: utf-8
require 'spec_helper'


describe Api::RealEstatesController do

  describe "#index" do
    before do
      @no_microsite = Fabricate :published_real_estate, :category => Fabricate(:category), :channels => [RealEstate::WEBSITE_CHANNEL]
      @gartenstadt = MicrositeDecorator.decorate Fabricate(:published_real_estate,
                                                           :category => Fabricate(:category),
                                                           :channels => [RealEstate::MICROSITE_CHANNEL],
                                                           :microsite_building_project => MicrositeBuildingProject::GARTENSTADT,
                                                           :figure => Fabricate.build( :figure)
                                                          )
    end

    it "gets real estates enabled for microsites" do
      get  'index', :format => :json
      response.body.should == [@gartenstadt].to_json
    end

    it "wraps the response with a callback if requested" do
      get  'index', :format => :json, :callback => 'callMeBack'
      response.body.should == "callMeBack(#{[@gartenstadt].to_json})"
    end

    it "doesn't get unpublished real estates" do
      [RealEstate::STATE_EDITING, RealEstate::STATE_IN_REVIEW].each do |state|
        Fabricate :real_estate,
          :state => state,
          :category => Fabricate(:category),
          :channels => [RealEstate::MICROSITE_CHANNEL],
          :microsite_building_project => MicrositeBuildingProject::GARTENSTADT,
          :figure => Fabricate.build(:figure),
          :editor => Fabricate(:cms_editor),
          :creator => Fabricate(:cms_editor)
      end

      get  'index', :format => :json
      response.body.should == [@gartenstadt].to_json
    end
  end

  describe "Expected json format of a real estate" do
    before do
      @gartenstadt = Fabricate(:published_real_estate,
                               :category => Fabricate(:category),
                               :channels => [RealEstate::MICROSITE_CHANNEL],
                               :figure => Fabricate.build( :figure, :rooms => 10, :floor => 3),
                               :microsite_building_project => MicrositeBuildingProject::GARTENSTADT
                              )
      # @decorated_gartenstadt = MicrositeDecorator.decorate @gartenstadt
    end

    it "contains the id" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['id'] == @gartenstadt._id
    end

    it "contains the number of rooms" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['rooms'] == 10
    end

    it "contains the floor label" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['floor_label'] == '3. Obergeschoss'
    end

    it "contains the house index" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['house'] == 'Haus M'
    end

    it "contains the surface" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['surface'] == '200 m²'
    end

    it "contains the price" do
      get 'index', :format => :json
      json = JSON.parse(response.body)
      gartenstadt_hash = json.first
      gartenstadt_hash['price'] == 'CHF 10000'
    end
  end
end
