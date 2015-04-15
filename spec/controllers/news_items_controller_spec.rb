require 'spec_helper'

describe NewsItemsController do

  describe 'handling GET /news_items.xml' do
    before do
      get :index, :format => :xml, :locale => :de
    end

    it "should render the action using XML" do
      response.should be_success
      response.should render_template('index')
      response.headers["Content-Type"].should eql("application/xml; charset=utf-8")
    end
  end

  describe 'handling GET /news_items.html' do
    it 'routes news items requests correctly' do
      expect(get: '/de/news_items')
        .to route_to(controller: 'news_items', action: 'index', locale: 'de')
    end

    # fix undefined method 'year' for nil:NilClass, when bots are crawling with wrong locale param
    it 'responds with 404 if wrong locale was sent' do
      expect{ get :index, locale: 'a-wrong-locale' }.to raise_error(ActionController::RoutingError)
    end
  end
end
