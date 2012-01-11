require 'spec_helper'

describe "Cms::RealEstates" do
  describe "GET /cms_real_estates" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get cms_real_estates_path
      response.status.should be(200)
    end
  end
end
