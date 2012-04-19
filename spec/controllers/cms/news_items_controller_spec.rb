# encoding: utf-8
require 'spec_helper'

describe Cms::NewsItemsController do

  it_should_behave_like "All CMS controllers not accessible to editors", Fabricate(:news_item)

end