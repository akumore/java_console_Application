require 'spec_helper'

describe Handout do
  let :real_estate do
    RealEstate.new :title => 'Some Real Estate'
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

  describe '#cache_key' do
    it 'does not fail' do
      lambda{ handout.cache_key(:html, :de) }.should_not raise_error
    end

    it 'returns a key' do
      handout.real_estate.stub!(:id).and_return('123')
      handout.cache_key(:html, :de).should == "/de/real_estates/123/Objektdokumentation-some-real-estate.html"
    end
  end
end
