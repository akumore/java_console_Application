require 'spec_helper'

describe Cms::JobsController do

  it_should_behave_like "All CMS controllers not accessible to editors", :job

end