# encoding: utf-8
require 'spec_helper'


describe Api::RealEstatesController do

  describe "#index" do
    before do
      @no_microsite = Fabricate :published_real_estate, :category=>Fabricate(:category), :channels=>[RealEstate::WEBSITE_CHANNEL]
      @gartenstadt = Fabricate :published_real_estate, :category=>Fabricate(:category), :channels=>[RealEstate::MICROSITE_CHANNEL]
    end

    it "gets real estates enabled for microsites" do
      get  'index', :format=>:json
      response.body.should == [@gartenstadt].to_json
    end

    it "wraps the response with a callback if requested" do
      get  'index', :format=>:json, :callback => 'callMeBack'
      response.body.should == "callMeBack(#{[@gartenstadt].to_json})"
    end

    it "doesn't get unpublished real estates" do
      [RealEstate::STATE_EDITING, RealEstate::STATE_IN_REVIEW].each do |state|
        Fabricate :real_estate, :state => state, :category => Fabricate(:category), :channels => [RealEstate::MICROSITE_CHANNEL]
      end

      get  'index', :format=>:json
      response.body.should == [@gartenstadt].to_json
    end
  end

end