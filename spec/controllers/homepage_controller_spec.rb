require 'spec_helper'

describe HomepageController do
  before do
    @sale_de = Fabricate :reference_project_for_sale
    @rent_de = Fabricate :reference_project_for_rent
    @sale_en = Fabricate :reference_project_for_sale, :locale => :en
    @rent_en = Fabricate :reference_project_for_rent, :locale => :en
  end

  describe "GET index" do
    describe "with default locale" do

      before do
        get :index
      end

      it "assigns all reference projects for sale to @projects_for_sale" do
        assigns(:projects_for_sale).to_a.should eq([@sale_de])
      end

      it "assigns all reference projects for rent to @projects_for_rent" do
        assigns(:projects_for_rent).to_a.should eq([@rent_de])
      end

    end

    describe "with locale :en" do

      before do
        I18n.locale = :en
        get :index, :locale => :en
      end

      after do
        I18n.locale = :de
      end

      it "assigns all english reference projects for sale to @projects_for_sale" do
        assigns(:projects_for_sale).to_a.should eq([@sale_en])
      end

      it "assigns all english reference projects for rent to @projects_for_rent" do
        assigns(:projects_for_rent).to_a.should eq([@rent_en])
      end

    end
  end

end
