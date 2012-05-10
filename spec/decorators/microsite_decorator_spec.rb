require 'spec_helper'

describe MicrositeDecorator do
 # workaround for issue: https://github.com/jcasimir/draper/issues/60
 # include Rails.application.routes.url_helpers
 # before :all do
 #   c = ApplicationController.new
 #   c.request = ActionDispatch::TestRequest.new
 #   c.set_current_view_context
 # end
 # end of workaround
 #

  context "Real estate for rent" do
    before do
      @real_estate =  Fabricate :real_estate, :offer => RealEstate::OFFER_FOR_RENT,
                      :pricing => Fabricate.build(:pricing_for_rent, :for_rent_netto => 2500),
                      :category=>Fabricate(:category)
      @decorated_real_estate = MicrositeDecorator.decorate @real_estate
    end

    it 'returns the rent price' do
      @decorated_real_estate.price.should == 'CHF 2500'
    end
  end

  context "Real estate for living" do
    before do
      @real_estate =  Fabricate :real_estate, :offer => RealEstate::OFFER_FOR_SALE,
                      :pricing => Fabricate.build(:pricing_for_sale, :for_sale => 2500000),
                      :category=>Fabricate(:category)
      @decorated_real_estate = MicrositeDecorator.decorate @real_estate
    end

    it 'returns price for sale' do
      @decorated_real_estate.price.should == 'CHF 2500000'
    end
  end

end
