require 'spec_helper'

describe Handout do
  let :real_estate do
    mock_model(RealEstate, :title => 'Some Real Estate')
  end

  let :handout do
    Handout.new(real_estate)
  end

  it 'has a path' do
    handout.should respond_to(:path)
  end

  it 'has an url' do
    handout.should respond_to(:url)
  end

  it 'has a title' do
    handout.filename.should == 'Objektdokumentation-some-real-estate'
  end
end
