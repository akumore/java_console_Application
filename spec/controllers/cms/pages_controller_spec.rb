require 'spec_helper'

describe Cms::PagesController do

  it_should_behave_like "All CMS controllers not accessible to editors", :page

end