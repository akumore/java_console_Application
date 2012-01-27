require 'spec_helper'

describe "cms/information/_form" do
  before(:each) do
    assign(:information, stub_model(Information).as_new_record)
  end

  it 'renders with is_developed check box' do
    category = stub_model(Category, :name=>'properties')
    assign(:real_estate, stub_model(RealEstate, :category=>category))

    render
    assert_select "input#information_is_developed"
  end

  it 'renders without is_developed check box' do
    category = stub_model(Category, :name=>'other_category')
    assign(:real_estate, stub_model(RealEstate, :category=>category))

    render
    assert_select "input#information_is_developed", false, "There shouldn't be an is_developed check box"
  end

  %w(house apartment).each do |category_name|
    it "renders with is_under_building_laws check box for real estate category '#{category_name}'" do
      category = stub_model(Category, :name=>category_name)
      assign(:real_estate, stub_model(RealEstate, :category=>category))

      render
      assert_select "input#information_is_under_building_laws"
    end
  end

  it "renders without is_under_building_laws check box other real estate categories than 'house' and 'apartment'" do
    category = stub_model(Category, :name=>'other_category')
    assign(:real_estate, stub_model(RealEstate, :category=>category))

    render
    assert_select "input#information_is_under_building_laws", false, "There shouldn't be an is_under_building_laws check box"
  end


end
