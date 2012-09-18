require 'spec_helper'

describe NewsItemsController, "handling GET /news_items.xml" do

  before do
    get :index, :format => :xml, :locale => :de
  end

  it "should render the action using XML" do
    response.should be_success
    response.should render_template('index')
    response.headers["Content-Type"].should eql("application/xml; charset=utf-8")
  end

end
