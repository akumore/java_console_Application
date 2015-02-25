require 'spec_helper'

describe NewsItem do
  describe '#published' do
    before :each do
      @news_item_1 = Fabricate(:news_item, published: true)
      @news_item_2 = Fabricate(:news_item, published: false)
    end

    it 'shows only published news items' do
      NewsItem.published.should eq [@news_item_1]
    end
  end
end
