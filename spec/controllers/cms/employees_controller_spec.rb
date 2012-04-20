require 'spec_helper'

describe Cms::EmployeesController do

  it_should_behave_like "All CMS controllers not accessible to editors", :employee

end